# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite Gaussian mixture implemented with manual `target += log_sum_exp(...)` scoring. SafeStan forbids arbitrary `target +=` scoring, and there is no equivalent built-in sampling statement for the general `K`-component mixture in this Stan program. Replacing it would require a substantive model rewrite rather than a minor same-density translation.
