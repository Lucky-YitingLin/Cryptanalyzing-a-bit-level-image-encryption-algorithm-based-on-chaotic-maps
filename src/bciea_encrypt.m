function [cipherImage, trace] = bciea_encrypt(plainImage, key)
%BCIEA_ENCRYPT Encrypt an 8-bit grayscale image with the corrected BCIEA model.
%
%   CIPHERIMAGE = BCIEA_ENCRYPT(PLAINIMAGE, KEY) runs binary bitplane
%   decomposition, corrected mutual diffusion, dynamic PWLCM confusion, and
%   bitplane composition.  It is a research reference implementation for
%   reproducing the cryptanalysis paper, not a production encryption scheme.
%
%   [CIPHERIMAGE, TRACE] additionally returns the intermediate streams and
%   permutations to support experiments and tests.  See BCIEA_DEFAULT_KEY for
%   the expected KEY structure.

key = bciea_validate_key(key);
[streamA1, streamA2] = bciea_bitplane_decompose(plainImage);
imageSize = size(plainImage);
streamLength = numel(streamA1);

[keyStream1, keyStream2] = bciea_generate_diffusion_key(imageSize, key);
[streamB1, streamB2] = bciea_diffuse(streamA1, streamA2, keyStream1, keyStream2, key.boundary_bits);

bitSum = sum(double(streamB1)) + sum(double(streamB2));
[indexY, indexZ] = bciea_generate_permutations(bitSum, streamLength, key);

% C2 receives B1 through Y; C1 receives B2 through Z.
streamC1 = zeros(1, streamLength, 'uint8');
streamC2 = zeros(1, streamLength, 'uint8');
streamC1(indexZ) = streamB2;
streamC2(indexY) = streamB1;
cipherImage = bciea_bitplane_compose(streamC1, streamC2, imageSize);

if nargout > 1
    trace = struct('stream_a1', streamA1, 'stream_a2', streamA2, ...
        'stream_b1', streamB1, 'stream_b2', streamB2, ...
        'stream_c1', streamC1, 'stream_c2', streamC2, ...
        'index_y', indexY, 'index_z', indexZ, 'bit_sum', bitSum);
end

end
