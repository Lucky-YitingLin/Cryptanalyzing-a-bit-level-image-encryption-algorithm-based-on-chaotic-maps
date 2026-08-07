function plainImage = bciea_recover_plaintext(targetCipherImage, equivalentKey, indexY, indexZ)
%BCIEA_RECOVER_PLAINTEXT Recover a target plaintext from equivalent attack keys.
%
%   PLAINIMAGE = BCIEA_RECOVER_PLAINTEXT(TARGET, EQUIVALENTKEY, Y, Z)
%   removes confusion with the recovered dynamic permutations and reverses
%   diffusion using the equivalent key streams.  No original PWLCM parameters
%   are required once the chosen-ciphertext attack has obtained these values.

[streamC1, streamC2] = bciea_bitplane_decompose(targetCipherImage);
streamLength = numel(streamC1);
validate_recovery_inputs(equivalentKey, indexY, indexZ, streamLength, size(targetCipherImage));

% This is the inverse of C1(Z) = B2 and C2(Y) = B1 in BCIEA_ENCRYPT.
streamB1 = streamC2(indexY);
streamB2 = streamC1(indexZ);
[streamA1, streamA2] = bciea_anti_diffuse(streamB1, streamB2, ...
    equivalentKey.key_stream1, equivalentKey.key_stream2, equivalentKey.boundary_bits);
plainImage = bciea_bitplane_compose(streamA1, streamA2, size(targetCipherImage));

end

function validate_recovery_inputs(equivalentKey, indexY, indexZ, streamLength, imageSize)
requiredFields = {'key_stream1', 'key_stream2', 'boundary_bits', 'stream_length', 'image_size'};
if ~isstruct(equivalentKey) || ~isscalar(equivalentKey) || ...
        ~all(isfield(equivalentKey, requiredFields))
    error('bciea:InvalidEquivalentKey', 'equivalentKey is incomplete or invalid.');
end
if equivalentKey.stream_length ~= streamLength || ...
        ~isequal(double(equivalentKey.image_size(:)).', double(imageSize(:)).')
    error('bciea:InvalidEquivalentKey', 'equivalentKey dimensions do not match the target cipher image.');
end
validate_permutation(indexY, streamLength, 'indexY');
validate_permutation(indexZ, streamLength, 'indexZ');
end

function validate_permutation(index, streamLength, name)
if ~isnumeric(index) || ~isvector(index) || numel(index) ~= streamLength || ...
        any(~isfinite(index(:))) || any(index(:) ~= floor(index(:))) || ...
        any(index(:) < 1) || any(index(:) > streamLength) || numel(unique(index)) ~= streamLength
    error('bciea:InvalidPermutation', '%s must be a permutation of 1:streamLength.', name);
end
end
