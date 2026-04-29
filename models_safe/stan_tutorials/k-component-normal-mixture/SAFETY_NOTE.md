# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite normal mixture implemented through per-observation log densities and manual `target += log_mix(theta, ps)` scoring. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this marginalized mixture with SafeStan sampling statements would require a substantive model rewrite, so no same-density minor translation is provided.
