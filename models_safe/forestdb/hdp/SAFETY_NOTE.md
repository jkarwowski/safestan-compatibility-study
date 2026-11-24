# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `y_counts_1` through `y_counts_3`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: aggregated token observations by document into protected multinomial counts. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
