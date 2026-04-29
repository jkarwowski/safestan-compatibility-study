# SafeStan Safety Note

Compatibility: minor.

Protected data: `R`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `R_safestan_copy`, a deterministic copy of `R`, because the original model uses `R` in transformed data and parameter bounds before the observation statement. Replaced the manual Jacobian/prior contribution `target += -2 * log(N)` with the built-in prior statement `N ~ pareto(C - R_safestan_copy + M, 1)`, whose log density is proportional to `-2 * log(N)` on the same support. The binomial observation of `R` is unchanged and remains the protected likelihood term.

Deterministic data augmentation: `R_safestan_copy = R`; for the supplied data this is `0`.
