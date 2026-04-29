# SafeStan Safety Note

Compatibility: minor.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block sampling statements so that every parameter prior appears before any model-block use of that parameter. In particular, the priors for `sigma_mu`, `alpha`, and `zeta` now precede the hierarchical prior for `mu`. The likelihood for the protected observation `complaints` is unchanged and remains a single top-level built-in sampling statement. The data are unchanged.
