# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is implemented by a custom marginalized hidden-state forward algorithm using `target += log(sum(gamma[n_occasions]))`. SafeStan forbids direct `target +=` scoring, and replacing this algorithm with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. The protected observation `y` is also used in `transformed data` to compute first-capture occasions before any possible SafeStan observation statement.
