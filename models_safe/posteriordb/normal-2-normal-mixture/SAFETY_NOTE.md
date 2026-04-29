# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring inside a loop. SafeStan forbids arbitrary `target +=` scoring, and replacing this with SafeStan sampling statements would require a substantive likelihood/model rewrite rather than a minor same-density translation. The parameter prior loop for `mu` could be mechanically vectorized, but the marginalized mixture likelihood remains incompatible.
