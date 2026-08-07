function [indexY, indexZ] = bciea_recover_permutations(c1QueryPlaintexts, c2QueryPlaintexts, equivalentKey, plan)
%BCIEA_RECOVER_PERMUTATIONS Recover the target Y and Z confusion permutations.
%
%   [Y, Z] = BCIEA_RECOVER_PERMUTATIONS(C1PLAINTEXTS, C2PLAINTEXTS,
%   EQUIVALENTKEY, PLAN) implements the divide-and-conquer step of the
%   chosen-ciphertext attack.  The two plaintext cell arrays are decryption
%   oracle results for the query groups returned by
%   BCIEA_BUILD_CHOSEN_CIPHERTEXTS.
%
%   Reapplying diffusion with EQUIVALENTKEY removes the diffusion layer.
%   The recovered B2 rows carry encoded Z labels from C1 queries, and the
%   recovered B1 rows carry encoded Y labels from C2 queries.  PLAN resolves
%   any label-bit complement selected during construction.

validate_query_inputs(c1QueryPlaintexts, c2QueryPlaintexts, equivalentKey, plan);
bitCount = plan.bit_count;
streamLength = plan.stream_length;
encodedZ = zeros(bitCount, streamLength, 'uint8');
encodedY = zeros(bitCount, streamLength, 'uint8');

for queryIndex = 1:bitCount
    [streamA1, streamA2] = bciea_bitplane_decompose(c1QueryPlaintexts{queryIndex});
    [~, streamB2] = bciea_diffuse(streamA1, streamA2, ...
        equivalentKey.key_stream1, equivalentKey.key_stream2, equivalentKey.boundary_bits);
    encodedZ(queryIndex, :) = streamB2;

    [streamA1, streamA2] = bciea_bitplane_decompose(c2QueryPlaintexts{queryIndex});
    [streamB1, ~] = bciea_diffuse(streamA1, streamA2, ...
        equivalentKey.key_stream1, equivalentKey.key_stream2, equivalentKey.boundary_bits);
    encodedY(queryIndex, :) = streamB1;
end

indexZ = decode_position_labels(encodedZ, plan);
indexY = decode_position_labels(encodedY, plan);

end

function validate_query_inputs(c1Queries, c2Queries, equivalentKey, plan)
if ~iscell(c1Queries) || ~iscell(c2Queries) || ...
        numel(c1Queries) ~= plan.bit_count || numel(c2Queries) ~= plan.bit_count
    error('bciea:InvalidQuerySet', 'Each query group must contain plan.bit_count plaintext images.');
end

requiredFields = {'key_stream1', 'key_stream2', 'boundary_bits', 'stream_length', 'image_size'};
if ~isstruct(equivalentKey) || ~isscalar(equivalentKey) || ...
        ~all(isfield(equivalentKey, requiredFields))
    error('bciea:InvalidEquivalentKey', 'equivalentKey is incomplete or invalid.');
end
if equivalentKey.stream_length ~= plan.stream_length || ...
        ~isequal(double(equivalentKey.image_size(:)).', double(plan.image_size(:)).')
    error('bciea:InvalidEquivalentKey', 'equivalentKey dimensions do not match the query plan.');
end

for queryIndex = 1:plan.bit_count
    if ~isequal(size(c1Queries{queryIndex}), plan.image_size) || ...
            ~isequal(size(c2Queries{queryIndex}), plan.image_size)
        error('bciea:InvalidQuerySet', 'Each oracle response must match the target image size.');
    end
end
end

function permutation = decode_position_labels(encodedRows, plan)
streamLength = plan.stream_length;
labels = zeros(1, streamLength, 'uint32');

for bit = 1:plan.bit_count
    row = encodedRows(bit, :);
    if plan.complemented(bit)
        row = uint8(1 - row);
    end
    labels = labels + uint32(row) * uint32(2 ^ (bit - 1));
end

permutation = double(labels) + 1;
if any(permutation < 1) || any(permutation > streamLength) || numel(unique(permutation)) ~= streamLength
    error('bciea:PermutationRecoveryFailed', ...
        'Recovered labels do not form a valid permutation; verify the oracle and query plan.');
end
end
