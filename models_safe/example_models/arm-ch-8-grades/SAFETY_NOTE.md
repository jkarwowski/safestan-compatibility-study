# SafeStan Safety Note

Compatibility: major.

Protected data: `final`.

Generated files: none.

Reason: the observed likelihood is `final ~ normal_id_glm(x, alpha, beta, sigma)`, with `midterm` used only as a predictor through the deterministic transformed-data matrix `x`. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors would change the posterior/log density, and the original implicit flat/improper priors cannot be represented as SafeStan-compliant built-in proper priors by a minor same-density rewrite.
