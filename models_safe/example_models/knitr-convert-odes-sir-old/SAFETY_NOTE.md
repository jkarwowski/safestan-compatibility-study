# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi_hat` and `B_hat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the elementwise Poisson likelihood for `stoi_hat` as one vectorized sampling statement on the top-level protected data variable. Added `stoi_lambda` in `transformed parameters` as the deterministic vector of Poisson rates, with `stoi_lambda[1] = y0[1] - y[1, 1]` and `stoi_lambda[n] = y[n - 1, 1] - y[n, 1]` for `n = 2, ..., N_t`. This preserves the same summed Poisson log likelihood while satisfying SafeStan's requirement that protected observations appear exactly once on the left side of a plain sampling statement. The `B_hat` likelihood was already a single top-level built-in sampling statement. The data file is unchanged.
