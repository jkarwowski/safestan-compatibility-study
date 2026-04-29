# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the observational likelihood `y ~ normal(theta[context_idx], sigma)` is unchanged and `y` remains the only protected data variable. The parameter priors were mechanically reorganized for SafeStan: `lambda ~ cauchy(0, 1)` was moved before any model-block use of `lambda`, and the loop of indexed prior statements for `theta_tilde[k]` was replaced by one vectorized top-level prior `theta_tilde ~ normal(0, theta_tilde_scale)` using a deterministic local scale vector. This preserves the same log density. No data fields were added; `data_safe.json` is the supplied data unchanged.
