# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the indexed likelihood loop was rewritten so that the protected top-level data variable `obs` is observed exactly once with a plain left-hand side (`obs ~ poisson_log(log_lambda_obs)`). The per-observation log rates are computed deterministically in a local vector before that sampling statement. The implicit bounded priors for `sd_alpha` and `sd_eps` were made explicit as `uniform(0, 5)` and `uniform(0, 3)`, and placed before those parameters are used as scales. No data transformation is required; `data_safe.json` is the supplied data unchanged.
