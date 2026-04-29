# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood itself is a direct built-in sampling statement, `switched ~ bernoulli_logit_glm(x, alpha, beta)`, with predictors computed only from unprotected context data. However, the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use in the model block. Adding proper priors for these unbounded parameters would change the posterior/log density, and there is no finite-bound implicit uniform prior to make explicit as a density-neutral minor rewrite.
