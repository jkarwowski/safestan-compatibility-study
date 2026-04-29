# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the original observed array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed likelihood statements inside nested loops with one vectorized built-in sampling statement on the top-level protected variable `y_safestan_flat`. Added `p_safestan_flat`, the matching row-major flattening of the original linear predictor matrix `p`. The original `y` is retained as context for the deterministic lag-history calculations (`n_avoid` and `n_shock`), while `y_safestan_flat` is the protected observed variable scored exactly once. In `data_safe.json`, `y_safestan_flat[j, t]` is flattened as `y_safestan_flat[(j - 1) * n_trials + t] = y[j, t]`; for the supplied data this is `[0, 1, 1, 1]`. No new observations were introduced and the posterior/log density is preserved for consistent data.
