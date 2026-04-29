# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ normal(a + b * x, sigma_y)`, while `x` and `N` are context data. However, the parameters `a`, `b`, and `sigma_y` have no explicit priors in the original Stan program. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, and the original implicit priors for these unconstrained or half-line-constrained parameters are improper rather than finite-bounded density-neutral priors that can be mechanically expressed as built-in sampling statements. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
