# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite normal mixture implemented with direct `normal_lupdf(...)` scoring and `target += log_mix(theta, ps)`. Replacing this with SafeStan-compatible plain sampling statements would require a substantive mixture/latent-state rewrite or a custom distribution, so no same-density minor translation is available under the SafeStan restrictions.
