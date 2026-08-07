function [plainImage, trace] = bciea_decrypt(cipherImage, key)
%BCIEA_DECRYPT Decrypt an image produced by the corrected BCIEA model.
%
%   PLAINIMAGE = BCIEA_DECRYPT(CIPHERIMAGE, KEY) first reconstructs the
%   dynamic confusion permutations from the cipher-image bit sum, then applies
%   corrected anti-diffusion and binary bitplane composition.  With matching
%   parameters this function is the inverse of BCIEA_ENCRYPT.
%
%   [PLAINIMAGE, TRACE] exposes intermediate values for reproducible research.
%   The routine is intentionally explicit about the corrected model because
%   the original wraparound diffusion equations are not uniquely decryptable.

key = bciea_validate_key(key);
[streamC1, streamC2] = bciea_bitplane_decompose(cipherImage);
imageSize = size(cipherImage);
streamLength = numel(streamC1);

% Confusion preserves the combined bit sum, so ciphertext determines Y and Z.
bitSum = sum(double(streamC1)) + sum(double(streamC2));
[indexY, indexZ] = bciea_generate_permutations(bitSum, streamLength, key);
streamB1 = streamC2(indexY);
streamB2 = streamC1(indexZ);

[keyStream1, keyStream2] = bciea_generate_diffusion_key(imageSize, key);
[streamA1, streamA2] = bciea_anti_diffuse(streamB1, streamB2, keyStream1, keyStream2, key.boundary_bits);
plainImage = bciea_bitplane_compose(streamA1, streamA2, imageSize);

if nargout > 1
    trace = struct('stream_a1', streamA1, 'stream_a2', streamA2, ...
        'stream_b1', streamB1, 'stream_b2', streamB2, ...
        'stream_c1', streamC1, 'stream_c2', streamC2, ...
        'index_y', indexY, 'index_z', indexZ, 'bit_sum', bitSum);
end

end
