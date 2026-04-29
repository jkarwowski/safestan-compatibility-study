# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation history `y` is scored through a marginalized capture-recapture/hidden-state forward algorithm implemented with `target += log(sum(gamma[n_occasions]))`. The likelihood also inspects `y` in `transformed data` to compute first-capture occasions and gates contributions based on that value. Replacing this manual marginalized likelihood with a SafeStan-compatible single built-in sampling statement for top-level protected `y` would require a substantive model rewrite and is not a minor same-density translation.
