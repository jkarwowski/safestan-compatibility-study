# SafeStan Safety Note

Compatibility: major.

Protected data: `post_test`.

Generated files: none.

Reason: `post_test` is the observed response and is scored once with the built-in `normal_id_glm` likelihood, but the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding priors for these unconstrained or half-constrained parameters would change the posterior/log density rather than being a minor same-density rewrite.
