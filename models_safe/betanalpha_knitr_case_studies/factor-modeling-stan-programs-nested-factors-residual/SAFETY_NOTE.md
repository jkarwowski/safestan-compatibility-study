# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that every parameter receives its unique built-in prior before any subsequent model-block use, including use in other hierarchical priors and through transformed parameters in the likelihood predictor. The local predictor `theta` is now declared first but assigned only after all priors. No data changes were made.
