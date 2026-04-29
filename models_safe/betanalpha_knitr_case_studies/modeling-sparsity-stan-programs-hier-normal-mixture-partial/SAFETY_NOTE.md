# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observational likelihood scores `y` with `y ~ normal(theta[context_idx], sigma)`, but the prior for `theta_tilde` is a marginalized two-component normal mixture implemented with forbidden manual scoring via `target += log_mix(...)`. SafeStan requires each parameter to have exactly one built-in prior sampling statement and forbids `target +=`. Replacing this mixture prior with SafeStan sampling statements would require a substantive model rewrite, so no same-density minor translation is provided.
