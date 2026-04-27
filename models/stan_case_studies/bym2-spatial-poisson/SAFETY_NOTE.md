# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the existing prior statements before the likelihood so that parameters are given priors before they are used in the protected-data observation. The protected outcome `y` remains a top-level data variable and is observed with the plain vectorized sampling statement `y ~ poisson_log(...)`. The custom ICAR density is used only as a prior for the latent parameter `phi`, not as a likelihood for protected observations. No data fields were added or changed.
