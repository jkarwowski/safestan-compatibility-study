# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed response, but it is scored as `y[n] ~ ...` inside a loop rather than as a single top-level protected variable. That part could be mechanically vectorized, but the model also has parameters (`b`, `mu_a`, `sigma_y`, and `sigma_a`) with no explicit proper built-in priors. SafeStan requires every parameter to have exactly one built-in prior before use; adding proper priors here would change the posterior/log density, and the existing implicit flat/improper priors cannot be represented as SafeStan sampling statements. Therefore this is not a minor same-density translation.
