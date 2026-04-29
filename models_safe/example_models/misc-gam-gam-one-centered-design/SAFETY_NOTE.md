# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ neg_binomial_2(exp(X * beta), alpha)`, so `y` is the protected interface variable. However, the remaining sampling statement is a P-spline penalty on the transformed expression `P * beta`, not a top-level parameter prior. SafeStan only permits sampling statements whose left side is a protected top-level data variable or a top-level parameter, and each parameter must have exactly one built-in prior before use. Replacing this rank-deficient difference-penalty prior with legal top-level priors for `beta`, `alpha`, and `lambda` would require a substantive change to the model density, not a minor same-density rewrite.
