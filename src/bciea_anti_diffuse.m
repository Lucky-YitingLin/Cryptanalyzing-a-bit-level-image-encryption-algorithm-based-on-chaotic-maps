function [streamA1, streamA2] = bciea_anti_diffuse(streamB1, streamB2, keyStream1, keyStream2, boundaryBits)
%BCIEA_ANTI_DIFFUSE Invert the corrected BCIEA mutual diffusion operation.
%
%   [A1, A2] = BCIEA_ANTI_DIFFUSE(B1, B2, K1, K2, BOUNDARYBITS) reverses
%   BCIEA_DIFFUSE.  The implementation uses the corrected first equations;
%   therefore it is a true inverse only when the same boundary convention is
%   used for encryption and decryption.
%
%   The function also accepts equivalent key streams recovered by the attack.
%   In that case BOUNDARYBITS should be [0 0], because the unknown boundary
%   contribution is folded into the first equivalent key bit.

[streamB1, streamB2, keyStream1, keyStream2, boundaryBits] = ...
    validate_anti_diffusion_inputs(streamB1, streamB2, keyStream1, keyStream2, boundaryBits);
streamLength = numel(streamB1);

% Reverse B2 to recover the shifted A2 sequence.
streamA22 = zeros(1, streamLength, 'uint8');
streamA22(1) = bitxor(bitxor(bitxor(streamB2(1), boundaryBits(2)), streamB1(1)), keyStream2(1));
for index = 2:streamLength
    streamA22(index) = bitxor(bitxor(bitxor(streamB2(index), streamA22(index - 1)), ...
        streamB1(index)), keyStream2(index));
end
streamA2 = circshift(streamA22, [0, -mod(sum(double(streamB1)), streamLength)]);

% Reverse B1, then undo the shift controlled by the recovered A2 stream.
streamA11 = zeros(1, streamLength, 'uint8');
streamA11(1) = bitxor(bitxor(bitxor(streamB1(1), boundaryBits(1)), streamA2(1)), keyStream1(1));
for index = 2:streamLength
    streamA11(index) = bitxor(bitxor(bitxor(streamB1(index), streamA11(index - 1)), ...
        streamA2(index)), keyStream1(index));
end
streamA1 = circshift(streamA11, [0, -mod(sum(double(streamA2)), streamLength)]);

end

function [b1, b2, k1, k2, boundary] = validate_anti_diffusion_inputs(b1, b2, k1, k2, boundary)
vectors = {b1, b2, k1, k2};
names = {'streamB1', 'streamB2', 'keyStream1', 'keyStream2'};
for index = 1:numel(vectors)
    value = vectors{index};
    if ~(isnumeric(value) || islogical(value)) || ~isvector(value) || isempty(value) || ...
            any(~isfinite(double(value(:)))) || any(value(:) ~= 0 & value(:) ~= 1)
        error('bciea:InvalidAntiDiffusionInput', '%s must be a non-empty binary vector.', names{index});
    end
end

b1 = uint8(reshape(b1, 1, []));
b2 = uint8(reshape(b2, 1, []));
k1 = uint8(reshape(k1, 1, []));
k2 = uint8(reshape(k2, 1, []));
if numel(b2) ~= numel(b1) || numel(k1) ~= numel(b1) || numel(k2) ~= numel(b1)
    error('bciea:InvalidAntiDiffusionInput', 'All anti-diffusion streams must have the same length.');
end

if ~(isnumeric(boundary) || islogical(boundary)) || numel(boundary) ~= 2 || ...
        any(~isfinite(double(boundary(:)))) || any(boundary(:) ~= 0 & boundary(:) ~= 1)
    error('bciea:InvalidAntiDiffusionInput', 'boundaryBits must be a two-element binary vector.');
end
boundary = uint8(reshape(boundary, 1, 2));
end
