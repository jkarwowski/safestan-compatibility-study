# SafeStan Safety Note

Compatibility: minor.

Protected data: `Yvec1`, `y0`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so all parameter priors occur before the parameters are used. Replaced the indexed loop likelihood for `y0[n]` with the equivalent vectorized statement `y0 ~ normal(mu0, sigma_y)`, so the protected data variable is observed exactly once with a plain top-level identifier. Removed the `transformed data` use of protected `y0` and recomputed `y0_mean` in the model block after `y0` has been observed. The supplied data are unchanged; no fields were added.
