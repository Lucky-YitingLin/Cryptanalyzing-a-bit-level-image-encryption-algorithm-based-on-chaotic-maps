function [streamB1, streamB2] = bciea_diffuse(streamA1, streamA2, keyStream1, keyStream2, boundaryBits)
%BCIEA_DIFFUSE Apply the corrected mutual bit-level diffusion operation.
%
%   [B1, B2] = BCIEA_DIFFUSE(A1, A2, K1, K2, BOUNDARYBITS) transforms two
%   binary BBD streams according to the BCIEA diffusion stage.  The first
%   equation uses BOUNDARYBITS instead of the original cyclic final-bit
%   feedback.  Passing [0 0] implements the paper's slight correction and
%   yields a unique inverse through BCIEA_ANTI_DIFFUSE.
%
%   All streams must be equal-length binary row or column vectors.

[streamA1, streamA2, keyStream1, keyStream2, boundaryBits] = ...
    validate_diffusion_inputs(streamA1, streamA2, keyStream1, keyStream2, boundaryBits);
streamLength = numel(streamA1);

% A11 is A1 shifted right by the Hamming weight of A2.
streamA11 = circshift(streamA1, [0, mod(sum(double(streamA2)), streamLength)]);
streamB1 = zeros(1, streamLength, 'uint8');
streamB1(1) = bitxor(bitxor(bitxor(streamA11(1), boundaryBits(1)), streamA2(1)), keyStream1(1));
for index = 2:streamLength
    streamB1(index) = bitxor(bitxor(bitxor(streamA11(index), streamA11(index - 1)), ...
        streamA2(index)), keyStream1(index));
end

% B1 controls the second shift before the mutually dependent B2 recurrence.
streamA22 = circshift(streamA2, [0, mod(sum(double(streamB1)), streamLength)]);
streamB2 = zeros(1, streamLength, 'uint8');
streamB2(1) = bitxor(bitxor(bitxor(streamA22(1), boundaryBits(2)), streamB1(1)), keyStream2(1));
for index = 2:streamLength
    streamB2(index) = bitxor(bitxor(bitxor(streamA22(index), streamA22(index - 1)), ...
        streamB1(index)), keyStream2(index));
end

end

function [a1, a2, k1, k2, boundary] = validate_diffusion_inputs(a1, a2, k1, k2, boundary)
vectors = {a1, a2, k1, k2};
names = {'streamA1', 'streamA2', 'keyStream1', 'keyStream2'};
for index = 1:numel(vectors)
    value = vectors{index};
    if ~(isnumeric(value) || islogical(value)) || ~isvector(value) || isempty(value) || ...
            any(~isfinite(double(value(:)))) || any(value(:) ~= 0 & value(:) ~= 1)
        error('bciea:InvalidDiffusionInput', '%s must be a non-empty binary vector.', names{index});
    end
end

a1 = uint8(reshape(a1, 1, []));
a2 = uint8(reshape(a2, 1, []));
k1 = uint8(reshape(k1, 1, []));
k2 = uint8(reshape(k2, 1, []));
if numel(a2) ~= numel(a1) || numel(k1) ~= numel(a1) || numel(k2) ~= numel(a1)
    error('bciea:InvalidDiffusionInput', 'All diffusion streams must have the same length.');
end

if ~(isnumeric(boundary) || islogical(boundary)) || numel(boundary) ~= 2 || ...
        any(~isfinite(double(boundary(:)))) || any(boundary(:) ~= 0 & boundary(:) ~= 1)
    error('bciea:InvalidDiffusionInput', 'boundaryBits must be a two-element binary vector.');
end
boundary = uint8(reshape(boundary, 1, 2));
end
