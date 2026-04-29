# SafeStan Safety Note

Compatibility: major.

Protected data: `watched`.

Generated files: none.

Reason: the observed likelihood is the built-in statement `watched ~ normal_id_glm(x, alpha, beta, sigma)`, with `encouraged` used only as a predictor through the deterministic transformed-data matrix `x`. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for the unbounded parameters, or for the lower-bounded scale parameter, would change the posterior/log density rather than being a mechanical same-density rewrite.
