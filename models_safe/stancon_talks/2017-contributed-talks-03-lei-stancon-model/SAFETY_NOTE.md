# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened the ad-platform matrix/array parameters for single top-level priors, rebuilt matrix forms deterministically, kept `y` as the single protected Bernoulli-logit observation, and corrected synthetic film dimensions to cover supplied `x_film` indexes.
