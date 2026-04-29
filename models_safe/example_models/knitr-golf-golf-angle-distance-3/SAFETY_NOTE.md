# SafeStan Safety Note

Compatibility: minor.

Protected data: `raw_proportions`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level data `raw_proportions`, deterministically computed as `to_vector(y) ./ to_vector(n)`, because the original likelihood scored a transformed-data variable and SafeStan requires protected observations to be top-level data identifiers. The original transformed-data computation of `raw_proportions` was removed. The original `y` input is retained but is not scored or used by the safe model. The three sigma priors were split into separate built-in sampling statements and moved before any parameter-dependent computations; this preserves the same prior density as the original vectorized normal statement.
