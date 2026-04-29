# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; `complaints` is a top-level data variable observed exactly once with a plain built-in `neg_binomial_2_log` sampling statement, and all parameters have built-in priors before use in the likelihood.
