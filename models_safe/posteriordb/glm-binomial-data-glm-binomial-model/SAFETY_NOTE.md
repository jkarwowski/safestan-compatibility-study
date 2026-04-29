# SafeStan Safety Note

Compatibility: as-is.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `C` is a top-level data variable and is observed exactly once with the built-in distribution `binomial_logit`. The other data variables (`nyears`, `N`, and `year`) are context inputs used as sizes, binomial totals, and covariates. Each parameter has exactly one built-in prior before the likelihood uses the transformed predictor `logit_p`.
