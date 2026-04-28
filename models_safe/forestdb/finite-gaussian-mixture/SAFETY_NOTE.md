# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring and direct calls to `normal_lpdf`. SafeStan forbids arbitrary `target +=` scoring and `_lp` distribution calls. Replacing this with SafeStan sampling statements would require a substantive rewrite of the marginalized mixture likelihood, not a minor same-density translation.
