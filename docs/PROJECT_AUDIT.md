# Project Audit and Migration Record

## Inventory

The repository's `HEAD` snapshot contained 309 tracked artifacts, including 105 MATLAB files. The code was organized as a personal working archive rather than a distributable project: paths were deeply nested, many function names were duplicated, scripts depended on current working directories and generated files, and several documents or binaries were unrelated to the 2024 BCIEA cryptanalysis paper.

The working tree initially exposed only a partially moved archive while all tracked files appeared as deleted. The cleanup therefore used Git history as the read-only source of record, compared the paper with the historical implementation stages, and rebuilt a small maintained tree.

## Disposition

| Historical material | Decision | Replacement or rationale |
| --- | --- | --- |
| Bitplane decomposition/composition copies | Consolidated | `src/bciea_bitplane_decompose.m` and `src/bciea_bitplane_compose.m` provide one validated, orientation-tested implementation. |
| PWLCM copies with contradictory branches | Reimplemented | `src/bciea_pwlcm.m` follows the symmetric PWLCM definition used by BCIEA and validates the parameter range. |
| Diffusion/encryption/decryption scripts | Consolidated and corrected | `bciea_diffuse`, `bciea_anti_diffuse`, `bciea_encrypt`, and `bciea_decrypt` expose an explicit corrected model. |
| Partial diffusion cryptanalysis scripts | Consolidated | `bciea_extract_equivalent_diffusion_key.m` derives the all-zero-query equivalent key without files, globals, or hard-coded dimensions. |
| Size-2x2 and image-scale confusion attack scripts | Consolidated | `bciea_build_chosen_ciphertexts.m`, `bciea_recover_permutations.m`, and `bciea_attack.m` implement the generic attack for arbitrary grayscale dimensions. |
| Generated ciphertexts, query images, MAT key files, and plotting output | Removed | They are reproducible from the demo and should not be versioned as source artifacts. |
| RGB, breadth-first, and unrelated chaotic-image experiments | Removed | They are outside the BCIEA cryptanalysis described by the included 2024 paper. |
| LaTeX backup series, Visio drafts, editor notes, and archive packages | Removed | They are historical authoring material, not required to run, verify, or understand the maintained code. |
| 2016 target-cipher PDF and other third-party binary resources | Not redistributed | Their license status is not established by this repository. The 2024 paper cites the original work by DOI. |
| 2024 cryptanalysis paper PDF | Retained with attribution | It is supplied unmodified in `docs/paper/` and is identified as CC BY 4.0 in `NOTICE`. |

## Maintained Contract

The maintained code intentionally guarantees only the following:

- It accepts validated two-dimensional 8-bit grayscale data.
- It runs without hidden images, MAT files, global variables, or current-directory assumptions.
- It models the corrected BCIEA equations needed for a unique decryptor.
- It reproduces the chosen-ciphertext attack mechanism and query-count formula discussed in the paper.
- It is covered by a deterministic MATLAB regression suite.

Historical paths and one-off experiments remain available in Git history for scholarly provenance, but are not part of the supported API.
