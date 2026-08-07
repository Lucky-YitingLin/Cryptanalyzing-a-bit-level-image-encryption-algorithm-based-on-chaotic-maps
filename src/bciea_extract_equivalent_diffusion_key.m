function equivalentKey = bciea_extract_equivalent_diffusion_key(zeroCipherPlaintext)
%BCIEA_EXTRACT_EQUIVALENT_DIFFUSION_KEY Recover diffusion keys from a zero query.
%
%   EQUIVALENTKEY = BCIEA_EXTRACT_EQUIVALENT_DIFFUSION_KEY(P0) implements
%   Section 4.1 of the accompanying paper.  P0 is the plaintext returned by
%   a decryption oracle for an all-zero cipher image of the same size as the
%   target.  Zero ciphertext makes both post-confusion streams zero, so the
%   two diffusion recurrences can be solved directly.
%
%   The returned structure contains KEY_STREAM1, KEY_STREAM2, and
%   BOUNDARY_BITS.  The boundary contribution is folded into the first key
%   bit, so BOUNDARY_BITS is always [0 0].  The result can be passed to
%   BCIEA_DIFFUSE and BCIEA_ANTI_DIFFUSE without knowing the real key.

[streamA1, streamA2] = bciea_bitplane_decompose(zeroCipherPlaintext);
streamLength = numel(streamA1);

% Under an all-zero ciphertext, anti-confusion returns B1 = B2 = 0.
% Consequently A22 equals A2 because the B1-controlled shift is zero.
equivalentKey2 = zeros(1, streamLength, 'uint8');
equivalentKey2(1) = streamA2(1);
for index = 2:streamLength
    equivalentKey2(index) = bitxor(streamA2(index), streamA2(index - 1));
end

% Recreate A11 from A1, then solve the B1 recurrence with B1 = 0.
streamA11 = circshift(streamA1, [0, mod(sum(double(streamA2)), streamLength)]);
equivalentKey1 = zeros(1, streamLength, 'uint8');
equivalentKey1(1) = bitxor(streamA11(1), streamA2(1));
for index = 2:streamLength
    equivalentKey1(index) = bitxor(bitxor(streamA11(index), streamA11(index - 1)), streamA2(index));
end

equivalentKey = struct( ...
    'key_stream1', equivalentKey1, ...
    'key_stream2', equivalentKey2, ...
    'boundary_bits', uint8([0 0]), ...
    'image_size', size(zeroCipherPlaintext), ...
    'stream_length', streamLength);

end
