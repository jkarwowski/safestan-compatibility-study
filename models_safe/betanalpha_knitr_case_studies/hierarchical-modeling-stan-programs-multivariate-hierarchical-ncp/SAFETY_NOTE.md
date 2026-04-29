# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the likelihood for `y` was moved from per-observation indexed sampling statements inside a loop to a single top-level sampling statement `y ~ normal(theta_obs, sigma)`. The helper transformed parameter `theta_obs` is a deterministic array with `theta_obs[n] = theta[indiv_idx[n]]`, preserving the same normal likelihood. The non-centered parameter prior for `eta` was vectorized from looped indexed statements to the single top-level statement `eta ~ normal(0, 1)`. No data changes were required; `data_safe.json` equals the supplied data.
