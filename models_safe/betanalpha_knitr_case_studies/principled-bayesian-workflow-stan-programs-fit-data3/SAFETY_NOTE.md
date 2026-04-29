# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed counts `y` are scored by a zero-inflated Poisson mixture implemented with manual `target +=` terms, including `log_mix(...)`, inside a loop and conditional on `y[n]`. SafeStan forbids arbitrary `target +=` scoring, and replacing this marginalized mixture likelihood with permitted built-in sampling statements would require a substantive likelihood/model rewrite rather than a minor mechanical translation. `N` is context data, not protected.
