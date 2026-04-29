# SafeStan Safety Note

Compatibility: minor.

Protected data: none. No top-level data variable is observed with a sampling statement; this is a prior-only model with all data used as context/configuration.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior sampling statements so each parameter is sampled before it is used as a hyperparameter in another prior. In particular, the `delta_factor*_tau` priors now appear before the corresponding centered residual priors that use those scale parameters. This preserves the same joint density because sampling-statement log-density contributions are additive and no likelihood terms or data values were changed.
