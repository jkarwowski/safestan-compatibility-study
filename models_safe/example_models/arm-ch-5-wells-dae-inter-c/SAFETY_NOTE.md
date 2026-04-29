# SafeStan Safety Note

Compatibility: major.

Protected data choice: `switched` is the observed response scored by the likelihood. `dist`, `arsenic`, and `educ` are context predictors used to construct the design matrix, and `N` is a size.

Generated files: none.

Reason: the likelihood itself uses a built-in sampling statement on a top-level protected data variable, but the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for unconstrained `real alpha` and `vector[6] beta` would change the original posterior/log density, so this cannot be repaired by a minor same-density rewrite.
