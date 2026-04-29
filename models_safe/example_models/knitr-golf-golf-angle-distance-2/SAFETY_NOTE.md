# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: `y` is the only top-level data variable observed on the left side of a sampling statement, so it is the protected interface variable. The parameter prior was moved before any model-block use of `sigma_angle` or `sigma_distance`, and the original vectorized prior `[sigma_angle, sigma_distance] ~ normal(0, 1)` was split into two equivalent built-in top-level parameter prior statements. The binomial likelihood for `y` is unchanged. No data fields were added or changed; `data_safe.json` is the supplied data.
