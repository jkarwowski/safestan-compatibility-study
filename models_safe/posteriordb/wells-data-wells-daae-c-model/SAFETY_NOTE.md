# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, so `switched` is the protected interface variable. Although that likelihood statement is a built-in distribution applied to a top-level data variable, the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for unconstrained `real`/`vector` parameters would change the original posterior/log density, so this cannot be repaired by a minor same-density rewrite.
