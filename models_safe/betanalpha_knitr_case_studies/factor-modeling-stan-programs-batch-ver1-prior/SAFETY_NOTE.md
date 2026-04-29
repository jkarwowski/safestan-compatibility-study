# SafeStan Safety Note

Compatibility: minor.

Protected data: none. This is a prior-only Stan program; no top-level data variable appears on the left side of a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block priors so that `delta_factor1_tau` is sampled before it is used as the scale parameter in the prior for `delta_factor1_cp`. This is a same-density mechanical change because Stan sampling statements only add log-density terms and no data or likelihood terms were changed. The data file is unchanged.
