# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the capture histories `y` are scored through a custom marginalized latent-state forward algorithm implemented with `target += log(sum(gamma[n_occasions]))`. SafeStan forbids direct `target +=` likelihood construction, and replacing this hidden-state marginal likelihood with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. The model also computes helper quantities from `y` in `transformed data` before any observation statement, which would require additional restructuring but does not change the main incompatibility.
