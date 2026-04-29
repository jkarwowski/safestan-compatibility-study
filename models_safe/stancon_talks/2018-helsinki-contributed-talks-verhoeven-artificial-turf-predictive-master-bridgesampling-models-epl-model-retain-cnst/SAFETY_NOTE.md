# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced each `target += ..._lpdf(...)` term with the equivalent built-in Stan sampling statement. The row-wise prior loop for `eta_a` was vectorized to the single equivalent statement `eta_a ~ normal(0, 1)` so that the top-level parameter is given exactly one prior outside control flow. The likelihood was rewritten as `goal_difference ~ student_t(...)`, observing the protected top-level data variable exactly once. No data values were changed; `data_safe.json` is the supplied data object.
