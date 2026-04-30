# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `y_successes`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: aggregated dog-specific Bernoulli outcomes by identical shock/avoid histories and observes protected binomial successes. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
