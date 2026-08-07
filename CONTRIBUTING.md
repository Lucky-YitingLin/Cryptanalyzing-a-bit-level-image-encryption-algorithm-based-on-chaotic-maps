# Contributing

Contributions are welcome when they improve reproducibility, clarity, or correctness of the maintained BCIEA cryptanalysis implementation.

## Before Opening a Change

1. Keep the change scoped to the corrected reference model, the selected-ciphertext attack, its tests, or its documentation.
2. Add or update a deterministic test in `tests/run_tests.m` whenever behavior changes.
3. Run `matlab -batch "addpath('tests'); run_tests"` from the repository root.
4. State whether the change is paper-faithful, a compatibility adjustment, or an experimental extension.

## Code Style

- Use one MATLAB function per file and match the file name to the function name.
- Start each public function with a MATLAB H1 line and document inputs, outputs, assumptions, and security-relevant details.
- Do not depend on `clear`, global variables, hidden files, hard-coded images, or the caller's current working directory.
- Preserve uint8 binary streams where appropriate and validate public inputs.
- Keep generated images, MAT files, editor backups, and benchmark output out of version control.

## Security Scope

This repository documents a known cryptanalytic result. Do not submit secrets, private images, or material obtained without authorization in an issue, pull request, or test fixture.
