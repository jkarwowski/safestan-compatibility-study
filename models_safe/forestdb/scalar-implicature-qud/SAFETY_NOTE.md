# SafeStan Safety Note

Compatibility: major.

Protected data choice: `observed_utterance` is the observed interface variable used by the likelihood calculation.

Generated files: none.

Reason: the likelihood is implemented with `target += log_sum_exp(listener_lp)`, where `listener_lp` depends on `observed_utterance` and on parameters through a marginalized latent-state/RSA listener computation. SafeStan forbids direct `target +=` scoring. Replacing this with a built-in sampling statement such as `categorical_logit` would require constructing a normalized distribution over utterances and would subtract a parameter-dependent normalizer, changing the posterior/log density. Introducing an explicit latent state or compensating factor would be a substantive model rewrite, not a minor same-density translation.
