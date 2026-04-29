# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so all parameter priors (`rho`, `alpha`, `sigma`, and `eta`) occur before those parameters are used to construct the latent Gaussian-process function `f`. This preserves the same posterior density because Stan sampling statements add commutative log-density terms. The protected observation `y` remains a top-level data variable and is observed exactly once with the built-in `normal` distribution. The data file is unchanged.
