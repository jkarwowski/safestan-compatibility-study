# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_times`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_survival(...) + log_hazard(...)` loop for `obs_times` with the equivalent built-in Weibull sampling statement `obs_times ~ weibull(alpha, sigma);`. This preserves the same density because the hazard-times-survival expression is exactly the Weibull density with shape `alpha` and scale `sigma`. No data values were changed or added.
