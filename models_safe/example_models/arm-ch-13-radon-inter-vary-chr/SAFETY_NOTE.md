# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for the bounded scale parameters `sigma_a1`, `sigma_a2`, and `sigma_y`. These parameters already had finite Stan constraints `<lower=0, upper=100>`, so the added uniform statements are constant on the existing support and preserve the posterior up to a normalizing constant while satisfying SafeStan's requirement that every parameter have exactly one built-in prior sampling statement before use. No data changes were made; `N`, `county`, `u`, and `x` remain context inputs.
