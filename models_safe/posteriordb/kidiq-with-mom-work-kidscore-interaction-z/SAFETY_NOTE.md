# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal(...)`, so `kid_score` is the protected interface variable. The predictors `mom_hs` and `mom_iq` and size `N` are context data. Although the likelihood itself uses a top-level protected data variable with a built-in distribution, the parameters `beta` and `sigma` have no explicit priors before they are used. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for the unconstrained `beta` or the half-line-constrained `sigma` would change the original posterior density rather than being a density-neutral mechanical rewrite.
