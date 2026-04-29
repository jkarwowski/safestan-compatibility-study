# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the data file is unchanged. In `model_safe.stan`, the prior for `delta_factor1_tau` was moved before `delta_factor1_cp ~ normal(0, delta_factor1_tau)` so that no parameter is used in the model block before its own sampling statement. This reordering only commutes existing log-density terms and preserves the posterior/log density.
