# SafeStan Safety Note

Compatibility: minor.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic ODE solution out of `transformed parameters` and into a local model-block variable assigned after the existing prior statements, so the explicit priors precede parameter use in the likelihood computation. The same ODE solution is recomputed in `generated quantities` to preserve the reported `mu_C` and posterior predictive draws. No data fields were added or changed.
