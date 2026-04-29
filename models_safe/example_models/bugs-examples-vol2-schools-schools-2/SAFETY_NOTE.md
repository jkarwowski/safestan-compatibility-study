# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block sampling statements so every parameter is sampled from its built-in prior before it is used. In particular, the hyper-priors for `gamma`, `sigma_Sigma`, and `L_Sigma` now precede the `alpha` prior, and all parameter priors precede construction of `Ymu` and the protected-data likelihood. The likelihood for `Y` remains a single top-level built-in sampling statement. `data_safe.json` is unchanged.
