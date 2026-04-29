# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the per-observation likelihood loop `y[n] ~ bernoulli_logit(...)` with a deterministic local linear-predictor vector `eta` followed by one vectorized built-in sampling statement `y ~ bernoulli_logit(eta)`. This preserves the same Bernoulli-logit likelihood while making the protected observation a top-level plain left-hand side, observed exactly once outside loops. Priors and data are unchanged.
