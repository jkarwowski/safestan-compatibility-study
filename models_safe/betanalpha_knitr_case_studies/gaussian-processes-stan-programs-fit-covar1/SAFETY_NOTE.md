# SafeStan Safety Note

Compatibility: major.

Protected data: `y_obs`.

Generated files: none.

Reason: the likelihood observes `y_obs` with a built-in `multi_normal_cholesky` sampling statement, but the parameters `rho`, `alpha`, and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior, and the existing lower-bound constraints correspond only to an improper flat density on the positive reals, not to a density-neutral finite built-in prior. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
