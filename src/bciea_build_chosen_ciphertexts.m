function [c1SignatureQueries, c2SignatureQueries, plan] = bciea_build_chosen_ciphertexts(targetCipherImage)
%BCIEA_BUILD_CHOSEN_CIPHERTEXTS Construct the same-sum queries from Algorithm 1.
%
%   [C1QUERIES, C2QUERIES, PLAN] = BCIEA_BUILD_CHOSEN_CIPHERTEXTS(TARGET)
%   creates the two groups of chosen cipher images used to recover the dynamic
%   confusion permutations.  Every generated image has the same combined BBD
%   bit sum as TARGET, so its confusion index sequences match the target's.
%
%   C1QUERIES encodes position labels in cipher stream C1 and recovers Z.
%   C2QUERIES encodes them in C2 and recovers Y.  Each group has
%   ceil(log2(L)) images, where L = 4 * HEIGHT * WIDTH.  PLAN records the
%   selected binary labels and is consumed by BCIEA_RECOVER_PERMUTATIONS.
%
%   The paper's construction is infeasible for very sparse or very dense
%   target cipher images because a balancing binary stream cannot have a
%   negative number of ones or more than L ones.  This function detects and
%   reports that mathematical precondition instead of silently changing the
%   requested sum.

[targetC1, targetC2] = bciea_bitplane_decompose(targetCipherImage);
imageSize = size(targetCipherImage);
streamLength = numel(targetC1);
targetBitSum = sum(double(targetC1)) + sum(double(targetC2));
bitCount = ceil(log2(double(streamLength)));

c1SignatureQueries = cell(1, bitCount);
c2SignatureQueries = cell(1, bitCount);
signatureRows = zeros(bitCount, streamLength, 'uint8');
complemented = false(1, bitCount);
positionLabels = uint32(0:streamLength - 1);

for bit = 1:bitCount
    signature = uint8(bitget(positionLabels, bit));
    [balanceCount, valid] = required_balance_count(targetBitSum, signature, streamLength);

    % A complemented code bit is equally decodable and can help non-power-of-two lengths.
    if ~valid
        alternative = uint8(1 - signature);
        [alternativeCount, alternativeValid] = required_balance_count(targetBitSum, alternative, streamLength);
        if ~alternativeValid
            error('bciea:UnconstructibleChosenCiphertext', ...
                ['The target bit sum cannot balance label bit %d under the paper''s ' ...
                'same-sum construction.  Choose a less extreme target ciphertext.'], bit);
        end
        signature = alternative;
        balanceCount = alternativeCount;
        complemented(bit) = true;
    end

    balancingStream = zeros(1, streamLength, 'uint8');
    if balanceCount > 0
        balancingStream(1:balanceCount) = 1;
    end

    signatureRows(bit, :) = signature;
    c1SignatureQueries{bit} = bciea_bitplane_compose(signature, balancingStream, imageSize);
    c2SignatureQueries{bit} = bciea_bitplane_compose(balancingStream, signature, imageSize);
end

plan = struct( ...
    'image_size', imageSize, ...
    'stream_length', streamLength, ...
    'bit_count', bitCount, ...
    'target_bit_sum', targetBitSum, ...
    'signature_rows', signatureRows, ...
    'complemented', complemented);

end

function [balanceCount, valid] = required_balance_count(targetBitSum, signature, streamLength)
balanceCount = targetBitSum - sum(double(signature));
valid = balanceCount >= 0 && balanceCount <= streamLength && balanceCount == floor(balanceCount);
end
