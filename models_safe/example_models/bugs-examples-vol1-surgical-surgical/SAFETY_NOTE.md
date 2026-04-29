# SafeStan Safety Note

Compatibility: as-is.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `r` is a top-level data variable and is observed exactly once with the built-in sampling statement `r ~ binomial_logit(n, b)`. The other data variables, `N` and `n`, are context inputs used for sizing and binomial trial counts. All parameters have exactly one built-in prior sampling statement before later model-block use.
