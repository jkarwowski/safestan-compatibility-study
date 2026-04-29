# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program contains no `model` block and no sampling statements or other scoring of top-level data variables; all data inputs are context inputs used for generated predictions.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no protected observations, no parameters requiring priors, and does not use forbidden log-density editing constructs such as `target +=`, `target()`, `reject()`, `fatal_error()`, or `_lp` functions.
