# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation array `y` is scored by a custom marginalized hidden-state forward algorithm using `target += log(sum(gamma[n_occasions]))` inside a loop. SafeStan forbids arbitrary `target +=` scoring, and replacing this algorithm with plain top-level built-in sampling statements for `y` would require a substantive model rewrite rather than a minor same-density translation. The model also reads `y` in `transformed data` to compute first captures before any SafeStan observation statement; that could only be handled after a valid SafeStan likelihood representation existed.
