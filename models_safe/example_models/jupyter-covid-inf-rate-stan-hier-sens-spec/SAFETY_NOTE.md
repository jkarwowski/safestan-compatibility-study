# SafeStan Safety Note

Compatibility: major.

Protected data: `y_sample`, `y_spec`, and `y_sens` are the top-level data variables observed by binomial sampling statements. `n_sample`, `n_spec`, `n_sens`, `J_spec`, and `J_sens` are context inputs.

Generated files: none.

Reason: although the likelihood observations are already expressed as built-in binomial sampling statements, the parameter discipline is not SafeStan-compatible. The unconstrained parameters `mu_spec` and `mu_sens` have no explicit built-in prior sampling statements, yet transformed quantities depending on them (`spec` and `sens`) are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for `mu_spec` and `mu_sens` would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
