function [recoveredPlainImage, report] = bciea_attack(targetCipherImage, decryptionOracle)
%BCIEA_ATTACK Run the paper's chosen-ciphertext attack against corrected BCIEA.
%
%   PLAINIMAGE = BCIEA_ATTACK(TARGET, DECRYPTIONORACLE) recovers the
%   plaintext of TARGET by querying a function handle that decrypts arbitrary
%   cipher images under one fixed unknown corrected-BCIEA key.  The routine
%   performs the all-zero query, creates 2 * ceil(log2(L)) same-sum queries,
%   recovers equivalent diffusion and confusion keys, and restores TARGET.
%
%   [PLAINIMAGE, REPORT] returns attack metadata, including the recovered
%   equivalent key and dynamic permutations.  This implementation is for
%   authorized research and reproduction of the accompanying paper only.

if ~isa(decryptionOracle, 'function_handle')
    error('bciea:InvalidOracle', 'decryptionOracle must be a function handle.');
end

% A zero cipher image makes both post-confusion streams zero, exposing diffusion.
zeroCipherImage = zeros(size(targetCipherImage), 'uint8');
zeroCipherPlaintext = decryptionOracle(zeroCipherImage);
equivalentKey = bciea_extract_equivalent_diffusion_key(zeroCipherPlaintext);

% The remaining queries preserve the target bit sum and therefore its Y and Z.
[c1SignatureQueries, c2SignatureQueries, plan] = bciea_build_chosen_ciphertexts(targetCipherImage);
c1QueryPlaintexts = cell(1, plan.bit_count);
c2QueryPlaintexts = cell(1, plan.bit_count);
for queryIndex = 1:plan.bit_count
    c1QueryPlaintexts{queryIndex} = decryptionOracle(c1SignatureQueries{queryIndex});
    c2QueryPlaintexts{queryIndex} = decryptionOracle(c2SignatureQueries{queryIndex});
end

[indexY, indexZ] = bciea_recover_permutations( ...
    c1QueryPlaintexts, c2QueryPlaintexts, equivalentKey, plan);
recoveredPlainImage = bciea_recover_plaintext(targetCipherImage, equivalentKey, indexY, indexZ);

if nargout > 1
    report = struct( ...
        'equivalent_key', equivalentKey, ...
        'index_y', indexY, ...
        'index_z', indexZ, ...
        'target_bit_sum', plan.target_bit_sum, ...
        'query_count', 1 + 2 * plan.bit_count, ...
        'query_plan', plan);
end

end
