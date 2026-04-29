# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi_hat` and `B_hat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the indexed/looped Poisson likelihood for `stoi_hat` into a deterministic local rate array `stoi_lambda` followed by a single vectorized sampling statement `stoi_hat ~ poisson(stoi_lambda)`. This preserves the original likelihood exactly while satisfying SafeStan's requirement that each protected data variable be observed once with a plain top-level identifier on the left side of `~`. The `B_hat` lognormal likelihood and all parameter priors were already in SafeStan-compatible sampling-statement form. No data fields were added or changed; `data_safe.json` is the supplied data unchanged. `N_t`, `t`, and `y0` are context inputs, not protected observations.
