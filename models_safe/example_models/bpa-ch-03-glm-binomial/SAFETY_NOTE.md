# SafeStan Safety Note

Compatibility: as-is.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `C` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `C ~ binomial_logit(N, logit_p);`. The variables `nyears`, `N`, and `year` are context inputs used as sizes, binomial totals, and covariates, and are not protected.
