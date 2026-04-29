# SafeStan Safety Note

Compatibility: major.

Protected data: `earn_pos`.

Generated files: none.

Reason: the likelihood is a built-in sampling statement, `earn_pos ~ bernoulli_logit_glm(x, alpha, beta)`, so `earn_pos` is the observed/protected interface variable. However, the parameters `alpha` and `beta` have no explicit priors. SafeStan requires every parameter to be sampled exactly once from a built-in prior before it is used. Adding proper priors to these unconstrained parameters would change the posterior/log density, and there is no finite-bounds implicit uniform prior to make explicit in a density-preserving way. Therefore this cannot be translated with only a minor same-density rewrite.
