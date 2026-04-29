# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the latent state prior for `x` from elementwise/loop sampling statements (`x[1] ~ ...`, `x[t] ~ ...`) to one top-level built-in multivariate normal prior, `x ~ multi_normal(...)`. The covariance matrix is the deterministic AR(1) covariance implied by the original Gaussian state evolution, so the joint density for `x` conditional on `phi` and `sigma_state` is unchanged. The protected observation `y` remains a top-level data variable scored exactly once by `y ~ normal(x, sigma_obs)`. No data fields were added or changed.
