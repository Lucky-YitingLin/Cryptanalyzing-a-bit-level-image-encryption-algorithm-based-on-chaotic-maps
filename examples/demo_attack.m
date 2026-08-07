function demo_attack()
%DEMO_ATTACK Reproduce the chosen-ciphertext recovery on a synthetic image.
%
%   Run this function from MATLAB after cloning the repository.  It creates a
%   deterministic grayscale image, encrypts it with the corrected BCIEA
%   reference model, exposes only a decryption-oracle handle to the attack,
%   and verifies that the recovered image exactly matches the original.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(projectRoot, 'src'));

height = 32;
width = 32;
[column, row] = ndgrid(uint16(0:height - 1), uint16(0:width - 1));
plainImage = uint8(mod(17 * row + 29 * column + bitxor(row, column), 256));

key = bciea_default_key();
% This nonzero boundary bit mirrors a historical corrected variant.
% The attack still succeeds because its equivalent key absorbs that bit.
key.boundary_bits = uint8([1 0]);

cipherImage = bciea_encrypt(plainImage, key);
decryptionOracle = @(candidateCipher) bciea_decrypt(candidateCipher, key);
[recoveredImage, report] = bciea_attack(cipherImage, decryptionOracle);

assert(isequal(plainImage, recoveredImage), 'The recovered image does not match the original image.');
fprintf('Attack succeeded for a %d-by-%d image using %d chosen-ciphertext queries.\n', ...
    height, width, report.query_count);

end
