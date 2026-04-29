# SafeStan Safety Note

Compatibility: as-is.

Protected data: none; the program has no `data` block and no observed sampling statements.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program is a prior/predictive simulator using only `transformed data` constants and `generated quantities`; it has no protected data interface, no parameters requiring priors, and no likelihood-scoring statements.
