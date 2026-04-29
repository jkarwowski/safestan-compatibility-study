# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that all parameters receive their priors before being used in computations or likelihood terms. Added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`, matching their finite bounded parameter declarations and making the implicit bounded-support priors explicit for SafeStan. The data are unchanged.
