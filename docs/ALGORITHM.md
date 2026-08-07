# Algorithm Notes

This document defines the maintained reference model and its relation to the cryptanalysis paper. It deliberately distinguishes the original BCIEA description from the corrected model needed for a deterministic decryption oracle.

## Reference Model

Given an 8-bit grayscale image of size `M x N`, binary bitplane decomposition produces two binary streams `A1` and `A2`, each of length `L = 4MN`:

- `A1` contains bitplanes 8 through 5.
- `A2` contains bitplanes 4 through 1.
- Every plane is serialized in top-to-bottom, left-to-right order.

`bciea_generate_diffusion_key` derives two binary key streams from a PWLCM sequence. It uses the odd/even bitplane grouping described by the 2016 BCIEA paper. `bciea_diffuse` then applies the two mutual XOR recurrences and cyclic shifts.

The original first diffusion equations include `A11(L)` and `A22(L)`. As discussed in Section 3 of the 2024 paper, that wraparound formulation is not one-to-one and cannot be uniquely decrypted. The maintained model uses the paper's correction: those feedback terms are absent. This is represented by `boundary_bits = [0 0]`.

For compatibility with historical corrected experiments, callers may set a fixed nonzero `boundary_bits` pair. The attack is still valid because the all-zero query absorbs each boundary value into the first bit of an equivalent key stream.

## Dynamic Confusion

After diffusion, let `s = sum(B1) + sum(B2)`. The confusion PWLCM state is initialized from `s / L`, then two sorted chaotic blocks produce permutations `Y` and `Z`.

The reference implementation uses the explicit assignments:

```text
C1(Z) = B2
C2(Y) = B1
```

Consequently, decryption computes `B1 = C2(Y)` and `B2 = C1(Z)`. Sorting the chaotic blocks is an intentional correction for an invertible permutation model; raw quantized chaotic values can repeat and are not sufficient as direct coordinates.

## Chosen-Ciphertext Attack

`bciea_attack` follows the paper's divide-and-conquer procedure.

1. Query the oracle with an all-zero cipher image. Confusion cannot change zeros, so both intermediate streams are zero.
2. Use the resulting plaintext to solve the equivalent diffusion streams. The first equivalent bit contains any fixed boundary contribution.
3. Compute the target cipher image's BBD bit sum. Build two groups of binary label images with the same sum: labels in `C1` recover `Z`; labels in `C2` recover `Y`.
4. Query the oracle for every label image. Reapply diffusion with the equivalent streams to remove diffusion and read the position labels from `B2` or `B1`.
5. Undo confusion with the recovered permutations, then anti-diffuse with the equivalent streams to recover the target plaintext.

For `L`-bit streams, the query count is `1 + 2 * ceil(log2(L))`. The attack assumes access to an authorized chosen-ciphertext decryption oracle under a single fixed key.

## Equal-Sum Construction Boundary

Each label query contains one position-label bit stream and one balancing stream. The balancing stream must have exactly:

```text
target_bit_sum - sum(label_stream)
```

ones. This quantity must fall in `[0, L]`. Extremely sparse or dense target bit sums can violate that condition, in which case the exact construction in the paper is unavailable. The implementation raises an explicit error rather than weakening the same-sum requirement.

## Non-Goals

- This project does not claim interoperability with every historical script in the original archive; several scripts use contradictory map definitions, fixed workspace state, duplicate function names, or incomplete inverse operations.
- This project does not treat chaos-based finite-precision sequences as cryptographically secure random generators.
- This project does not authorize attacks on systems without the owner's explicit permission.
