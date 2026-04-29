# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. No top-level data variable is observed/scored by a sampling statement; `n`, `sigma_x`, and `sigma_y` are context inputs for deterministic simulation and generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `phi ~ normal(0, 1)` for the sole parameter, and there is no protected observation likelihood to rewrite.
