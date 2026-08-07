function image = bciea_bitplane_compose(upperBits, lowerBits, imageSize)
%BCIEA_BITPLANE_COMPOSE Reconstruct an 8-bit grayscale image from BBD streams.
%
%   IMAGE = BCIEA_BITPLANE_COMPOSE(UPPERBITS, LOWERBITS, IMAGESIZE) is the
%   inverse of BCIEA_BITPLANE_DECOMPOSE.  IMAGESIZE is a two-element vector
%   [HEIGHT WIDTH].  Both streams must contain 4 * HEIGHT * WIDTH binary
%   elements in the high-to-low bitplane order used by the decomposition.

[height, width] = validate_image_size(imageSize);
pixelCount = height * width;
streamLength = 4 * pixelCount;
upperBits = validate_bit_stream(upperBits, streamLength, 'upperBits');
lowerBits = validate_bit_stream(lowerBits, streamLength, 'lowerBits');

image = zeros(height, width, 'uint8');

% Rebuild bitplanes 8 through 5 from the first stream.
for bit = 8:-1:5
    offset = (8 - bit) * pixelCount;
    plane = reshape(upperBits(offset + 1:offset + pixelCount), width, height).';
    image = bitor(image, bitshift(uint8(plane), bit - 1));
end

% Rebuild bitplanes 4 through 1 from the second stream.
for bit = 4:-1:1
    offset = (4 - bit) * pixelCount;
    plane = reshape(lowerBits(offset + 1:offset + pixelCount), width, height).';
    image = bitor(image, bitshift(uint8(plane), bit - 1));
end

end

function [height, width] = validate_image_size(imageSize)
if ~isnumeric(imageSize) || numel(imageSize) ~= 2 || any(~isfinite(imageSize(:))) || ...
        any(imageSize(:) < 1) || any(imageSize(:) ~= floor(imageSize(:)))
    error('bciea:InvalidImageSize', 'imageSize must be a two-element vector of positive integers.');
end

height = double(imageSize(1));
width = double(imageSize(2));
end

function bits = validate_bit_stream(bits, expectedLength, name)
if ~(isnumeric(bits) || islogical(bits)) || ~isvector(bits) || numel(bits) ~= expectedLength
    error('bciea:InvalidBitStream', '%s must be a binary vector of length %d.', name, expectedLength);
end

bits = reshape(bits, 1, []);
if any(~isfinite(double(bits))) || any(bits ~= 0 & bits ~= 1)
    error('bciea:InvalidBitStream', '%s must contain only zero and one.', name);
end
bits = uint8(bits);
end
