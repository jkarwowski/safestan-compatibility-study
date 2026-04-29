# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring inside a loop. SafeStan forbids `target +=` and requires each protected observation to be scored exactly once as a top-level left-hand side of a built-in sampling statement. Stan has no built-in distribution corresponding to this finite Gaussian mixture, so replacing the likelihood would require a substantive model rewrite rather than a minor same-density translation.
