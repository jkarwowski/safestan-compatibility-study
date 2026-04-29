# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered three hyperparameter prior statements so that `delta_factor1_tau`, `delta_factor2_tau`, and `delta_factor3_tau` are sampled before they are used as scales in hierarchical priors. This is a mechanical same-density change because Stan sampling statements add to the log density commutatively. No data fields were changed.
