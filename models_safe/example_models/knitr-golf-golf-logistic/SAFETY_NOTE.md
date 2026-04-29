# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed response scored by the built-in likelihood `binomial_logit`. However, the parameters `a` and `b` are unconstrained and have no explicit priors before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for `a` and `b` would change the posterior/log density, and there is no density-neutral built-in prior corresponding to the original improper flat priors on unconstrained reals. Therefore this cannot be translated with only a minor same-density rewrite.
