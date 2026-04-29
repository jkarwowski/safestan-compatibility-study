# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter prior `theta ~ normal(0, 1)` appears before `theta` is used in the protected-data likelihood `y ~ normal(theta, 1)`. This preserves the same posterior/log density because the two unconditional sampling statements commute. No data changes were made; `N` remains an unprotected context input.
