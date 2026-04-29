# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring and explicit `normal_lpdf(...)` calls inside a loop. SafeStan forbids arbitrary `target +=` scoring and `_lp` distribution-function calls. Replacing this with SafeStan sampling statements would require a substantive model rewrite, so no same-density minor translation is provided.
