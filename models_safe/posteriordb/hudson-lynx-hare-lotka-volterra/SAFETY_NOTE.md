# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `y_init`, `y_1`, and `y_2`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: split the two measured population columns into protected lognormal vectors. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
