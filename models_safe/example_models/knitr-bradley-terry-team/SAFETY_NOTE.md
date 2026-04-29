# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the pointwise likelihood inside the loop into a deterministic computation of a vector `eta` followed by a single vectorized sampling statement `y ~ bernoulli_logit(eta)`. This preserves the same Bernoulli-logit likelihood while making the protected observation a top-level left-hand side used exactly once and outside loops. No data fields were added or changed.
