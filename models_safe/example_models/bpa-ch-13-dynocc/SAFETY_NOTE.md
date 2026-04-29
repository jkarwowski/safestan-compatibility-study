# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed detection history used by the likelihood through the derived counts `sum_y`.

Generated files: none.

Reason: the likelihood is a marginalized hidden Markov/forward-algorithm calculation implemented with manual `target += log(sum(gam[nyear]))` scoring. SafeStan forbids arbitrary `target +=` scoring, and replacing this algorithm with plain built-in sampling statements for a top-level protected variable would require a substantive model rewrite rather than a minor same-density translation. The model also reads `y` in `transformed data` before any possible protected observation, but this is secondary to the manual marginalized likelihood issue.
