# SafeStan Safety Note

Compatibility: minor.

Protected data: `R`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `R_safestan_copy`, a deterministic copy of `R`, because the original model uses `R` in `transformed data` and `generated quantities` before/away from the SafeStan observation point. Those uses now read the copy, while the protected variable `R` is observed exactly once with a plain built-in sampling statement. Added `theta ~ uniform(0, theta_max);` to make the finite bounded implicit prior on `theta` explicit for SafeStan's unique-prior requirement. In `data_safe.json`, `R_safestan_copy` is exactly equal to `R` from the supplied data.
