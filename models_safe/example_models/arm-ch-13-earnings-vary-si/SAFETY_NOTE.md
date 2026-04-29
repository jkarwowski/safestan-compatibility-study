# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_earn`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level data variable `log_earn` so the originally scored transformed-data response is a SafeStan-protected top-level observation. In `data_safe.json`, `log_earn[i] = log(earn[i])` deterministically from the supplied `earn`. Removed the transformed-data computation of `log_earn`. Reordered the `sigma_a1`, `sigma_a2`, and `sigma_y` prior statements so `sigma_a1` and `sigma_a2` are given priors before being used in the priors for `a1` and `a2`. The original `earn`, `eth`, `height`, and `N` remain unprotected context data.
