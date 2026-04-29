# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter prior (`rho`, `alpha`, `sigma`, and `eta`) appears before any use of the corresponding parameter in model-block computations. The Gaussian-process latent value `f` is computed after these priors. This preserves the same posterior/log density. No data changes were made; `data_safe.json` equals the supplied input data.
