# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_observed`, a deterministic tail copy of the originally scored observations `y[3:T]`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_observed` with deterministic relation `y_safestan_observed[i] = y[i + 2]` for `i = 1, ..., T - 2`, because the original model sampled indexed elements `y[t]` inside a loop. SafeStan requires protected data to be a top-level identifier sampled exactly once outside loops. The scalar likelihood loop was replaced by an equivalent vectorized normal sampling statement using a local `y_hat` vector computed after the parameter priors. The original `y` remains context data for the moving-average residual recursion; no new observations were introduced and the posterior/log density is preserved for data satisfying the documented copy relation.
