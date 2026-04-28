# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a two-component Gaussian mixture marginalized with `target += log_mix(...)` and direct `normal_lpdf(...)` scoring inside a loop. Replacing this with SafeStan plain sampling statements would require introducing or otherwise changing the latent component-label structure or likelihood representation, which is a substantive model rewrite rather than a minor same-density mechanical translation.
