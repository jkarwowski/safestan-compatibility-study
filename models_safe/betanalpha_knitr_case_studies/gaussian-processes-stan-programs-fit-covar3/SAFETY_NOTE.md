# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter priors for `rho`, `alpha`, and `sigma` occur before those parameters are used to construct the Gaussian-process covariance matrix. The covariance calculation was placed in a nested local block after the priors. This preserves the same posterior/log density while satisfying SafeStan's requirement that each parameter be sampled from its prior before use. No data changes were required.
