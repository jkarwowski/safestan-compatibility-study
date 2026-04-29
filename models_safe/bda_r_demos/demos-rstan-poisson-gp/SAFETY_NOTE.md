# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that every parameter receives its unique built-in prior sampling statement before any parameter-dependent computation is performed. In the original program, `alpha` and `lscale` were used to build the Gaussian-process covariance before their priors. The protected observation `y` remains a top-level data variable observed exactly once with `y ~ poisson_log(...)`. No data changes were required; `data_safe.json` is the supplied data unchanged.
