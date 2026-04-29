# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation model scores `y` with `y ~ normal(theta[context_idx], sigma)`, so `y` is the protected interface variable. However, the prior for the parameter vector `theta` is a marginalized two-component normal mixture implemented with `target += log_mix(...)` inside a loop. SafeStan forbids direct `target +=` scoring and requires each parameter to receive exactly one built-in prior sampling statement before use. Replacing this marginalized mixture prior with SafeStan-compatible sampling statements would require a substantive model change, such as introducing latent mixture structure or changing the prior family, so no minor same-density translation is available.
