# SafeStan Safety Note

Compatibility: as-is.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `r` is a top-level data variable and is scored exactly once with the built-in sampling statement `r ~ binomial(n, p);`. The other data variables (`N`, `n`, and `x`) are context inputs used as sizes, trial counts, and predictors. Parameters `alpha_star` and `beta` each have exactly one built-in prior before the protected observation is scored.
