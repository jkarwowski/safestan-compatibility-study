# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_times`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_survival(obs_times[n], gamma) + log_hazard(obs_times[n], gamma)` loop with the equivalent built-in vectorized sampling statement `obs_times ~ exponential(gamma)`. This preserves the same log density for nonnegative observation times because the original contribution is `log(gamma) - gamma * obs_times[n]`. No data fields were added or changed.
