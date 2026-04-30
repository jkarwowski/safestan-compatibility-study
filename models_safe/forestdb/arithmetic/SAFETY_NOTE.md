# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `counts_1` through `counts_4`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: split the original count table into protected multinomial row observations. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
