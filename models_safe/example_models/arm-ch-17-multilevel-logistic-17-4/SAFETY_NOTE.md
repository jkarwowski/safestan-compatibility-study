# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for the protected observation is the built-in statement `y ~ bernoulli(p)`, but the model is not SafeStan-compatible because several parameters, including `sigma`, `sigma_age`, `sigma_edu`, `sigma_state`, `sigma_region`, and `sigma_age_edu`, have no prior sampling statement. SafeStan requires every parameter to be scored exactly once by a built-in prior before use. Adding proper priors to these positive scale parameters would change the original posterior/log density, and the unused `sigma` parameter cannot be made SafeStan-compatible without changing or removing an improper flat factor. Therefore this requires a substantive density change rather than a minor same-density rewrite.
