# SafeStan Safety Note

Compatibility: major.

Protected data: `y` would be the modeled interface. `K` and `N` are context inputs.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite mixture implemented with manual `target += log_mix(theta, ps)` scoring after computing component log densities with `normal_lupdf`. SafeStan forbids arbitrary `target +=` scoring, and Stan has no equivalent built-in sampling statement for this mixture likelihood. Replacing it would require a substantive model rewrite or a likelihood change, so no SafeStan-compatible same-density minor translation is produced.
