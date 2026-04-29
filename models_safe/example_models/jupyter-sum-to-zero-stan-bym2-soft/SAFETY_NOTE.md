# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the sole observed data variable scored by a sampling statement (`y ~ poisson_log(...)`). The model is not SafeStan-compatible because it uses a manual `target +=` term to define the BYM2/ICAR spatial prior for `phi`, and `phi` therefore has no single top-level built-in prior sampling statement. Replacing this custom graph-structured prior with SafeStan sampling statements would require a substantive prior/density rewrite rather than a minor mechanical translation.
