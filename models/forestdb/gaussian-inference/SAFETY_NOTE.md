# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the model has explicit proper priors for `mu` and `sigma`, and observes the top-level protected data `y` with a plain vectorized sampling statement.
