# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_flat`, a deterministic row-major reshape of the original observed `y` with `y_flat[(j - 1) * n_trials + t] = y[j, t]`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_flat` to `data_safe.json` using that deterministic flattening. The original `y` is retained as context for the lagged history calculations, so the protected variable is not read before its single observation. Replaced the nested cellwise Bernoulli sampling statements with one vectorized `y_flat ~ bernoulli(p_safestan)`. Replaced the two indexed beta priors with one vectorized top-level prior `beta ~ uniform(beta_lower, beta_upper)`. These are mechanical same-density rewrites for the supplied data; no new non-deterministic data values were introduced.
