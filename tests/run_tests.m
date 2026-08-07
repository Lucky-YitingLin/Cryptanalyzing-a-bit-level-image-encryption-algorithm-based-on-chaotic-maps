function run_tests()
%RUN_TESTS Execute deterministic regression tests for the BCIEA reference model.
%
%   RUN_TESTS validates the BBD round trip, corrected encryption/decryption,
%   and the end-to-end chosen-ciphertext attack.  It uses only MATLAB base
%   functionality and is designed to run with MATLAB's -batch option.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(projectRoot, 'src'));

test_bitplane_round_trip();
test_corrected_cipher_round_trip();
test_chosen_ciphertext_attack();

fprintf('All BCIEA regression tests passed.\n');

end

function test_bitplane_round_trip()
% A non-square image detects accidental column-major/row-major transpositions.
image = uint8(reshape(mod(0:14 * 11 - 1, 256), 14, 11));
[upperBits, lowerBits] = bciea_bitplane_decompose(image);
reconstructed = bciea_bitplane_compose(upperBits, lowerBits, size(image));
assert(isequal(image, reconstructed), 'Binary bitplane decomposition is not invertible.');
end

function test_corrected_cipher_round_trip()
% Verify the reference model works with the default mathematical correction.
rng(20240807, 'twister');
plainImage = uint8(randi([0, 255], 19, 13));
key = bciea_default_key();
cipherImage = bciea_encrypt(plainImage, key);
recoveredImage = bciea_decrypt(cipherImage, key);
assert(isequal(plainImage, recoveredImage), 'Corrected BCIEA encryption/decryption is not a round trip.');
end

function test_chosen_ciphertext_attack()
% Exercise the full attack on a non-square historical boundary-bit variant.
rng(20240808, 'twister');
plainImage = uint8(randi([0, 255], 13, 17));
key = bciea_default_key();
key.boundary_bits = uint8([1 0]);
cipherImage = bciea_encrypt(plainImage, key);
decryptionOracle = @(candidateCipher) bciea_decrypt(candidateCipher, key);

[recoveredImage, report] = bciea_attack(cipherImage, decryptionOracle);
expectedQueryCount = 1 + 2 * ceil(log2(4 * numel(plainImage)));

assert(isequal(plainImage, recoveredImage), 'Chosen-ciphertext attack did not recover the target plaintext.');
assert(report.query_count == expectedQueryCount, 'Attack query count differs from the paper formula.');
assert(numel(unique(report.index_y)) == numel(report.index_y), 'Recovered Y is not a permutation.');
assert(numel(unique(report.index_z)) == numel(report.index_z), 'Recovered Z is not a permutation.');
end
