# SafeStan Safety Note

Compatibility: minor.

Manual translation date: 2026-04-30.

Protected data: `word_counts_1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: aggregated words by document into protected multinomial word counts. This avoids unsupported array/matrix-valued distribution calls while preserving the parameter-dependent log density up to data-only multinomial/binomial constants where observations were aggregated.
