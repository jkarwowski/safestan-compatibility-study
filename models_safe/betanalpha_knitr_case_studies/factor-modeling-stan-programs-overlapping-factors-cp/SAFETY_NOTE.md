# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that every parameter is given its built-in prior sampling statement before it is used to compute the linear predictor or to parameterize another prior. In particular, the hierarchical scale parameters are sampled before the packed factor effects that use them as scales. The observation `y` remains a top-level protected data variable and is observed exactly once with `y ~ normal(theta, sigma)`. No data fields were added; `data_safe.json` is the supplied data.
