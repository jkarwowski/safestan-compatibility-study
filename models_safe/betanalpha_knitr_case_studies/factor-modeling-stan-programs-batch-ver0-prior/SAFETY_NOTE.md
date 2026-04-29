# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. This is a prior-only model; no top-level data variable is observed/scored by a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `baseline ~ normal(0, 1);`, and there is no protected data interface to score.
