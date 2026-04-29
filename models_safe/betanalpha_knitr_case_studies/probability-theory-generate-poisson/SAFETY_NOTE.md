# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program does not condition on any top-level data variable with a sampling statement; `l` is a context input used only to generate a posterior predictive/generated quantity with `poisson_rng`.
