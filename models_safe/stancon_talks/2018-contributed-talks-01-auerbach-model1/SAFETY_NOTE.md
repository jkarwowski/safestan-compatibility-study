# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`, `z`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that every parameter is given its built-in prior before any parameter-dependent computation. In the original program, `lambda` was computed from `beta_1` through `beta_5` and `sigma_1` through `sigma_5` before those parameters' prior sampling statements. The rewritten model places the priors first and then computes `lambda` in a local nested block before the likelihood. This is a same-density mechanical rewrite because multiplication of prior and likelihood factors is order-independent. No data fields or values were changed.
