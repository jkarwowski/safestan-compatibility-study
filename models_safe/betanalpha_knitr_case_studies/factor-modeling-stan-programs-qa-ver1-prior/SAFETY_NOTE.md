# SafeStan Safety Note

Compatibility: minor.

Protected data: none. This is a prior-only Stan program; no top-level data variable is observed on the left side of a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `delta_main_tau ~ normal(0, 1)` prior to occur before the `packed_delta_main_cp` prior, because the latter uses `delta_main_tau` as a scale and SafeStan requires each parameter to be sampled before any model-block use. This changes only the order of additive log-density terms and preserves the original prior/posterior density. `data_safe.json` is unchanged.
