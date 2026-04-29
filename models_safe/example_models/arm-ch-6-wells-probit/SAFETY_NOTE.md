# SafeStan Safety Note

Compatibility: major.

Protected data: `switc`.

Generated files: none.

Reason: the observed likelihood is `switc ~ bernoulli(Phi(alpha + x * beta))`, so `switc` is the protected interface variable. However, the parameters `alpha` and `beta` have no sampling statements; in the original Stan program they have implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, and there is no density-preserving built-in improper prior rewrite for these unconstrained parameters.
