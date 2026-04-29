# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is the built-in statement `y ~ poisson_log_glm(...)`, so `y` is the protected interface variable and the other data variables are context inputs. However, the top-level parameters `alpha`, `beta`, and `sigma` have no prior sampling statements, and `sigma` is used in `lambda ~ normal(0, sigma)` before any prior for `sigma`. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these parameters would change the original density, which uses implicit improper flat priors, so this cannot be translated by a minor same-density rewrite.
