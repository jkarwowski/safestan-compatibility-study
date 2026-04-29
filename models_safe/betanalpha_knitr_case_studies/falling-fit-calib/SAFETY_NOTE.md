# SafeStan Safety Note

Compatibility: as-is.

Protected data: `obs_t_calib`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `obs_t_calib` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The parameter `sigma_t` has a built-in prior before it is used in the observation model.
