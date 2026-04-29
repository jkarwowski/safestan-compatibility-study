# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ poisson_log(...)`, but the model also assigns the spatial `phi` prior with a manual `target += -0.5 * dot_self(phi[neighbors[1]] - phi[neighbors[2]])` ICAR term. SafeStan forbids `target +=` and requires every parameter prior to be a built-in distribution sampling statement on a top-level parameter. Replacing this ICAR penalty with SafeStan-compatible sampling statements would require a substantive prior/model rewrite, not a minor same-density translation.
