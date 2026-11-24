# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `r_1` through `r_5`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: expanded response-pattern IDs into protected per-question Bernoulli response arrays. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
