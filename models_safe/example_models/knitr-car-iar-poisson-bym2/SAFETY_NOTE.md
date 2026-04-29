# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood for `y` is a built-in `poisson_log` sampling statement, but the model also defines the spatial prior for parameter `phi` using manual `target += -0.5 * dot_self(phi[node1] - phi[node2])` scoring and an expression-valued sampling statement `sum(phi) ~ normal(...)`. SafeStan forbids `target +=`, requires each parameter to have exactly one built-in prior sampling statement on a top-level parameter before use, and does not allow expression-valued parameter sampling targets. Replacing the intrinsic CAR/BYM2 prior with SafeStan-compatible built-in priors would be a substantive density rewrite rather than a minor mechanical translation.
