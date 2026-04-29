# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed variable scored by the likelihood.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring inside a loop. SafeStan forbids arbitrary `target +=` scoring, and there is no equivalent built-in Stan sampling statement for this finite mixture likelihood. Replacing it would require a substantive model rewrite rather than a minor same-density translation.
