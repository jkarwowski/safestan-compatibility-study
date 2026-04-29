# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood for `y` is a marginalized hidden Markov model computed by a forward algorithm using `normal_lpdf(...)` calls and manual `target += log_sum_exp(...)` scoring. SafeStan requires each protected observation to be scored exactly once as a plain top-level left-hand side of a built-in sampling statement. Replacing this forward-algorithm likelihood with SafeStan sampling statements would require a substantive latent-state/model rewrite or custom/manual scoring, so it is not a minor same-density translation. The model also uses manual `target +=` prior contributions, which are forbidden in SafeStan.
