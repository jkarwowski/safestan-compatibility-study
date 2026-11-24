# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reparameterized GP standard-normal matrices as vector parameters and preserves the normal observation vector. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
