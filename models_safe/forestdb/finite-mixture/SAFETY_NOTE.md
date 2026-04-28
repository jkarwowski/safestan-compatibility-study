# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped manual `target += log_mix(...)` Bernoulli-mixture likelihood with one built-in vectorized Bernoulli sampling statement. This is density-preserving here because, for binary `y` and simplex `theta`,

`log_mix(theta[1], bernoulli_lpmf(y | p[1]), bernoulli_lpmf(y | p[2])) = bernoulli_lpmf(y | theta[1] * p[1] + theta[2] * p[2])`.

No data fields were added or changed. The generated quantities were left unchanged.
