# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` priors for `mean_s` and `mean_r`, matching the original bounded parameters' implicit uniform priors. Replaced the loop of row-wise multinomial likelihood statements with the vectorized built-in statement `marr ~ multinomial(pr);` so the protected top-level data variable is observed exactly once, with a plain identifier on the left-hand side and outside any loop. No data fields were added or changed; `n_occasions` remains an unprotected context input.
