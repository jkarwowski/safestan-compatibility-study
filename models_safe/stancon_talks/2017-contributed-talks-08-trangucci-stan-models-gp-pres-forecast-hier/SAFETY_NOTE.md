# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened GP standard-normal matrices for top-level priors, rebuilt matrices deterministically, kept protected `y` in one vectorized normal likelihood, and reduced synthetic `N_years` to avoid generated-quantities indexing beyond `year_re`.
