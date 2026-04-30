# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened offense/defense eta matrices for single top-level priors, rebuilt matrices deterministically, kept protected `goal_difference` in one vectorized student-t likelihood, and adjusted synthetic `n_weeks` to cover supplied week indexes.
