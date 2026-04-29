# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior sampling statements so that `rho`, `alpha`, `a`, and `eta` are each sampled exactly once before they are used to construct the Gaussian-process covariance and latent function. This preserves the same posterior density because the Stan model block log-density contributions are additive. No data changes were required.
