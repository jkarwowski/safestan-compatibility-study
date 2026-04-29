# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_theta` and `sigma_y`. These parameters were already finite-bounded as `real<lower=0, upper=100>`, so the added uniform sampling statements make the implicit bounded-support prior explicit, changing the log density only by constants. The prior for `sigma_theta` is placed before `theta` uses it, and the prior for `sigma_y` is placed before `y` uses it. No data changes were required.
