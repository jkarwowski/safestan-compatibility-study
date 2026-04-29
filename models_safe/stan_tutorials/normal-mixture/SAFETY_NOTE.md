# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed/modelled interface variable in the mixture likelihood.

Generated files: none.

Reason: the likelihood is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring and explicit `normal_lupdf(...)` terms. SafeStan forbids arbitrary `target +=` likelihood construction, and there is no equivalent built-in sampling statement for this marginalized mixture. Replacing it would require a substantive model rewrite rather than a minor same-density translation.
