# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered parameter prior sampling statements so every parameter is given its prior before any model-block use. Replaced the looped prior `alpha[m] ~ multi_normal(gamma, Sigma)` with the equivalent vectorized top-level statement `alpha ~ multi_normal(gamma, Sigma)`, which preserves the same summed log density while satisfying SafeStan's requirement that parameter priors are not placed inside loops and use top-level parameter identifiers. No data changes were made.
