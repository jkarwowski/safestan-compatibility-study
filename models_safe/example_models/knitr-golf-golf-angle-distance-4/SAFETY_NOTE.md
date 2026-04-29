# SafeStan Safety Note

Compatibility: minor.

Protected data: `raw_proportions`, `overshot`, and `distance_tolerance`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level data `raw_proportions` with deterministic relation `raw_proportions[j] = y[j] / n[j]` for each `j`; this replaces the transformed-data observation on the left side of the normal likelihood with a protected top-level data variable. Removed the transformed-data declaration of `raw_proportions`. Split the vectorized prior `[sigma_angle, sigma_distance, sigma_y] ~ normal(0, 1)` into one built-in prior statement per parameter and moved all parameter/protected-data sampling statements before later uses. The likelihood and prior log-density contributions are otherwise unchanged.
