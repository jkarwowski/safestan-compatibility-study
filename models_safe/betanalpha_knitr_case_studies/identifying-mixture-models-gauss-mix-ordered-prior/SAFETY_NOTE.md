# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring inside a loop. SafeStan forbids direct `target +=` manipulation, and there is no equivalent built-in Stan sampling distribution for this mixture likelihood. Replacing it would require a substantive model rewrite or a change to the represented density, so no SafeStan-compatible minor translation is produced.
