function [indexY, indexZ] = bciea_generate_permutations(bitSum, streamLength, key)
%BCIEA_GENERATE_PERMUTATIONS Create the dynamic confusion index permutations.
%
%   [Y, Z] = BCIEA_GENERATE_PERMUTATIONS(BITSUM, STREAMLENGTH, KEY) derives
%   the two permutations used by the BCIEA confusion stage.  BITSUM is the
%   combined Hamming weight of the two intermediate streams.  Because
%   confusion preserves that weight, the same value can be calculated from a
%   cipher image during decryption and during the chosen-ciphertext attack.
%
%   Sorting each PWLCM block makes every returned index set a permutation.
%   This is necessary for an invertible reference model and matches the
%   corrected experiment scripts bundled with the historical project.

key = bciea_validate_key(key);
validateattributes(bitSum, {'numeric'}, {'scalar', 'real', 'finite', 'nonnegative'});
validateattributes(streamLength, {'numeric'}, {'scalar', 'real', 'finite', 'positive'});

if bitSum ~= floor(bitSum) || streamLength ~= floor(streamLength)
    error('bciea:InvalidConfusionInput', 'bitSum and streamLength must be integers.');
end
if bitSum > 2 * streamLength
    error('bciea:InvalidConfusionInput', 'bitSum cannot exceed twice the stream length.');
end

streamLength = double(streamLength);
initialState = mod(key.confusion_initial + double(bitSum) / streamLength, 1);
sequence = bciea_pwlcm(initialState, key.confusion_parameter, ...
    key.transient, 2 * streamLength);

% SORT returns the original positions, which are valid 1-based MATLAB indices.
[~, indexY] = sort(sequence(1:streamLength), 'ascend');
[~, indexZ] = sort(sequence(streamLength + 1:end), 'ascend');
indexY = reshape(indexY, 1, []);
indexZ = reshape(indexZ, 1, []);

end
