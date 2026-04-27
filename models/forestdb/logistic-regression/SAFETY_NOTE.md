# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The binary outcome `y` is a top-level data variable observed with a plain vectorized `bernoulli_logit` sampling statement, and `beta` has an explicit proper prior before use in the likelihood.
