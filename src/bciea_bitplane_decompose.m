function [upperBits, lowerBits] = bciea_bitplane_decompose(image)
%BCIEA_BITPLANE_DECOMPOSE Convert an 8-bit grayscale image into two streams.
%
%   [UPPERBITS, LOWERBITS] = BCIEA_BITPLANE_DECOMPOSE(IMAGE) implements the
%   binary bitplane decomposition (BBD) used by BCIEA.  UPPERBITS contains
%   bitplanes 8, 7, 6, and 5; LOWERBITS contains bitplanes 4, 3, 2, and 1.
%   Each row is serialized in image order: top-to-bottom and left-to-right.
%
%   IMAGE must be a two-dimensional image with integral values in [0, 255].
%   The two returned row vectors contain uint8 values limited to 0 and 1.

validate_grayscale_image(image);
image = uint8(image);

[height, width] = size(image);
pixelCount = height * width;
upperBits = zeros(1, 4 * pixelCount, 'uint8');
lowerBits = zeros(1, 4 * pixelCount, 'uint8');

% Store the high four planes first, preserving a row-major pixel order.
for bit = 8:-1:5
    offset = (8 - bit) * pixelCount;
    plane = uint8(bitget(image, bit));
    upperBits(offset + 1:offset + pixelCount) = reshape(plane.', 1, pixelCount);
end

% Store the low four planes in the same order and with the same layout.
for bit = 4:-1:1
    offset = (4 - bit) * pixelCount;
    plane = uint8(bitget(image, bit));
    lowerBits(offset + 1:offset + pixelCount) = reshape(plane.', 1, pixelCount);
end

end

function validate_grayscale_image(image)
% Keep the public helper strict so accidental RGB or floating inputs are visible.
if ~(isnumeric(image) || islogical(image)) || ndims(image) ~= 2 || isempty(image)
    error('bciea:InvalidImage', 'Image must be a non-empty two-dimensional numeric array.');
end

values = double(image(:));
if any(~isfinite(values)) || any(values < 0) || any(values > 255) || any(values ~= floor(values))
    error('bciea:InvalidImage', 'Image values must be integral values in [0, 255].');
end
end
