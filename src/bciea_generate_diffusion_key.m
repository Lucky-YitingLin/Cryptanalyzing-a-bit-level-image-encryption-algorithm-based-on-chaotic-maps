function [keyStream1, keyStream2] = bciea_generate_diffusion_key(imageSize, key)
%BCIEA_GENERATE_DIFFUSION_KEY Derive the two binary PWLCM diffusion streams.
%
%   [K1, K2] = BCIEA_GENERATE_DIFFUSION_KEY(IMAGESIZE, KEY) implements the
%   initialization stage of BCIEA.  A PWLCM sequence is quantized to bytes,
%   then odd bitplanes form K1 and even bitplanes form K2, matching the
%   grouping stated in the original BCIEA description.
%
%   IMAGESIZE is [HEIGHT WIDTH].  Both outputs are uint8 row vectors of
%   length 4 * HEIGHT * WIDTH and contain only binary values.

key = bciea_validate_key(key);
[height, width] = validate_image_size(imageSize);
pixelCount = height * width;

sequence = bciea_pwlcm(key.diffusion_initial, key.diffusion_parameter, ...
    key.transient, pixelCount);
symbols = uint8(mod(floor(sequence * 1e14), 256));

% The original BCIEA key schedule groups odd and even bitplanes separately.
keyStream1 = uint8([bitget(symbols, 7), bitget(symbols, 5), ...
    bitget(symbols, 3), bitget(symbols, 1)]);
keyStream2 = uint8([bitget(symbols, 8), bitget(symbols, 6), ...
    bitget(symbols, 4), bitget(symbols, 2)]);

end

function [height, width] = validate_image_size(imageSize)
if ~isnumeric(imageSize) || numel(imageSize) ~= 2 || any(~isfinite(imageSize(:))) || ...
        any(imageSize(:) < 1) || any(imageSize(:) ~= floor(imageSize(:)))
    error('bciea:InvalidImageSize', 'imageSize must be a two-element vector of positive integers.');
end

height = double(imageSize(1));
width = double(imageSize(2));
end
