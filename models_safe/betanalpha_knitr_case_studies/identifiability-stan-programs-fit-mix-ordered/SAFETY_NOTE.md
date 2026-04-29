# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (`N` is a context size).

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring over indexed observations. SafeStan forbids `target +=`, and the protected observation cannot be scored through indexed manual `_lpdf` calls. Replacing this with SafeStan sampling statements would require a substantive mixture-model rewrite rather than a minor same-density translation.
