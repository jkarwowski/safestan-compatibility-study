# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened `eta_a` for a single top-level normal prior, rebuilt it deterministically, and kept protected `goal_difference` in one vectorized student-t likelihood.
