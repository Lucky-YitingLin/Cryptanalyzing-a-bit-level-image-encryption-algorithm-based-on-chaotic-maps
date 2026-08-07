# Cryptanalyzing a Bit-Level Image Encryption Algorithm Based on Chaotic Maps

[中文版](README.zh-CN.md) | [Paper PDF](docs/paper/cryptanalyzing-bciea-2024.pdf) | [Algorithm notes](docs/ALGORITHM.md) | [Project audit](docs/PROJECT_AUDIT.md)

Research implementation of the chosen-ciphertext attack described in:

> Heping Wen, Yiting Lin, and Zhaoyang Feng. "Cryptanalyzing a bit-level image encryption algorithm based on chaotic maps." *Engineering Science and Technology, an International Journal*, 51, 101634, 2024. https://doi.org/10.1016/j.jestch.2024.101634

## Scope

This repository is a reproducible MATLAB implementation for analyzing the bit-level image encryption algorithm based on chaotic maps (BCIEA). It provides:

- A corrected, invertible BCIEA reference model using binary bitplane decomposition, PWLCM-driven key streams, mutual diffusion, and dynamic confusion.
- The chosen-ciphertext attack from the paper: an all-zero query recovers equivalent diffusion keys, and same-sum queries recover the target's dynamic confusion permutations.
- An executable demo and deterministic regression tests.
- A cleaned repository layout with one maintained implementation instead of historical copies, debug scripts, generated images, and unrelated experiments.

> **Research-only warning:** BCIEA has the structural weaknesses analyzed in the paper. This code is for authorized cryptanalysis, education, and reproducible research. It is not a secure encryption library and must not be used to protect sensitive data.

## Paper Result

For a grayscale image of size `M x N`, define `L = 4MN`. Under the chosen-ciphertext model, the paper requires:

| Quantity | Result |
| --- | --- |
| Zero-ciphertext queries | 1 |
| Same-sum queries | `2 * ceil(log2(L))` |
| Total query complexity | `1 + 2 * ceil(log2(L))` |
| Example for `256 x 256` images | 37 queries |

The reported timing in the paper is specific to its experimental platform and should not be treated as a benchmark for this refactored implementation.

## Repository Layout

```text
src/        Maintained MATLAB implementation and attack primitives
examples/   Self-contained end-to-end demonstration
tests/      Deterministic regression tests
docs/       Algorithm notes, audit record, and the cited paper PDF
LICENSE     Apache License 2.0 for repository software and documentation
NOTICE      Attribution and license notice for the included paper PDF
```

The module boundaries are intentional:

- `bciea_encrypt.m` and `bciea_decrypt.m` implement the corrected reference cipher.
- `bciea_extract_equivalent_diffusion_key.m` implements the all-zero-query result.
- `bciea_build_chosen_ciphertexts.m` implements the equal-bit-sum query construction.
- `bciea_recover_permutations.m` and `bciea_recover_plaintext.m` implement the recovery stages.
- `bciea_attack.m` orchestrates the full attack through an injected decryption oracle.

## Requirements

- MATLAB R2019b or later. The repository is tested with MATLAB R2026a.
- No MATLAB toolbox is required for the implementation, demo, or tests.
- A two-dimensional 8-bit grayscale image represented by integral values in `[0, 255]`.

## Download and Run

Clone the repository:

```bash
git clone https://github.com/Lucky-YitingLin/Cryptanalyzing-a-bit-level-image-encryption-algorithm-based-on-chaotic-maps.git
cd Cryptanalyzing-a-bit-level-image-encryption-algorithm-based-on-chaotic-maps
```

Run the regression suite:

```bash
matlab -batch "addpath('tests'); run_tests"
```

Run the end-to-end demonstration:

```bash
matlab -batch "addpath('examples'); demo_attack"
```

`demo_attack` creates a deterministic synthetic image, encrypts it with the reference model, exposes only a decryption-oracle handle to the attack, and asserts exact recovery. It uses no bundled test images or hidden intermediate files.

## MATLAB API

The shortest complete experiment is:

```matlab
addpath('src');

key = bciea_default_key();
plainImage = uint8(randi([0, 255], 32, 32));
cipherImage = bciea_encrypt(plainImage, key);

% In a real chosen-ciphertext experiment this represents the authorized oracle.
oracle = @(candidateCipher) bciea_decrypt(candidateCipher, key);
[recoveredImage, report] = bciea_attack(cipherImage, oracle);

assert(isequal(plainImage, recoveredImage));
fprintf('Queries used: %d\n', report.query_count);
```

`bciea_default_key()` contains public demonstration values only. The corrected model uses `boundary_bits = [0 0]`, which corresponds to removing the non-invertible final-bit feedback identified in the paper. The attack also supports fixed historical boundary-bit variants because the all-zero query folds those bits into the equivalent key.

## Reproduction Notes

1. The original BCIEA first equations use wraparound feedback from the last bit and do not define a one-to-one decryptor. The reference cipher implements the paper's slight correction, documented in [Algorithm notes](docs/ALGORITHM.md).
2. The dynamic confusion sequences depend on the combined BBD bit sum. Chosen query images must preserve the target's bit sum to reuse its permutations.
3. The paper's binary balancing construction cannot represent every extremely sparse or dense target bit sum. `bciea_build_chosen_ciphertexts` reports this precondition explicitly rather than generating invalid queries.
4. Finite-precision chaotic maps are modeled for reproducibility, not endorsed as a secure key-generation mechanism.

## Validation

`tests/run_tests.m` checks:

- Bitplane decomposition and composition for a non-square image.
- Corrected BCIEA encryption/decryption round-trip behavior.
- Complete attack recovery against a fixed historical boundary-bit variant.
- The query-count formula and recovered permutation validity.

## Historical Cleanup

The repository history contained 309 tracked artifacts, including 105 MATLAB files spread across overlapping encryption attempts, partial attack stages, generated result images, archival LaTeX material, and an unrelated breadth-first image-cipher experiment. The maintained tree keeps the attack path described by the 2024 paper and replaces hand-operated scripts with parameterized, tested functions. See [Project audit](docs/PROJECT_AUDIT.md) for the migration record and rationale.

## Citation

If this repository or its methodology contributes to your work, cite the paper:

```bibtex
@article{wen2024cryptanalyzing,
  title   = {Cryptanalyzing a bit-level image encryption algorithm based on chaotic maps},
  author  = {Wen, Heping and Lin, Yiting and Feng, Zhaoyang},
  journal = {Engineering Science and Technology, an International Journal},
  volume  = {51},
  pages   = {101634},
  year    = {2024},
  doi     = {10.1016/j.jestch.2024.101634}
}
```

Machine-readable metadata is available in [CITATION.cff](CITATION.cff).

## License and Attribution

The maintained software and repository documentation are available under the [Apache License 2.0](LICENSE). The included paper PDF is an unmodified third-party scholarly work licensed under CC BY 4.0; see [NOTICE](NOTICE) for its required attribution. The 2016 target-cipher paper and unlicensed historical binary assets are not redistributed in this cleaned source tree.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a change. Contributions should preserve reproducibility, add tests for behavioral changes, and clearly distinguish a paper-faithful result from an optional experimental extension.

## Repository History Note

本开源代码受人员变动、实验室搬迁、设备损坏等多种因素影响，代码版本可能存在细微差异，代码可能为早期 Demo 版本或迭代修复过程中的中间版本，但项目对应的核心思想与实现方法保持一致。
