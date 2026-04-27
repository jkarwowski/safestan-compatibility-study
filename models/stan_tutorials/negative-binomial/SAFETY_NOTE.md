# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the model has explicit proper priors for `alpha` and `beta` before use, and observes the top-level protected count data `y` with a plain vectorized `neg_binomial` sampling statement.
