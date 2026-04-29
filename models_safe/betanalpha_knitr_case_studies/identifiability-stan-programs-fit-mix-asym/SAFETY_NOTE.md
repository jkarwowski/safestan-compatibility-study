# SafeStan Safety Note

Compatibility: major.

Protected data: `y` would be the modelled observation interface; `N` is only a size/context input.

Generated files: none.

Reason: the likelihood for `y` is a marginalized asymmetric two-component normal mixture implemented with `target += log_mix(...)`. SafeStan forbids manual target increments, and Stan has no equivalent built-in sampling statement for this mixture likelihood. Replacing it would require a substantive model rewrite or a likelihood change rather than a minor same-density translation. The indexed priors on `mu[1]` and `mu[2]` could be mechanically vectorized, but the mixture likelihood remains incompatible.
