# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed data used in the marginalized mixture likelihood. `N` is a size/context input and is not protected.

Generated files: none.

Reason: the likelihood is implemented with manual `target += log_mix(...)` scoring over `y[n]`, including explicit `normal_lpdf` calls. SafeStan forbids arbitrary `target +=` scoring and `_lp` calls. Replacing this marginalized finite-mixture likelihood with SafeStan sampling statements would require a substantive model rewrite, not a minor same-density translation.
