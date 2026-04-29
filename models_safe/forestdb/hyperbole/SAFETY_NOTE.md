# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood is implemented with manual `target += log_sum_exp(listener_lp)` scoring of a marginalized latent state calculation. SafeStan forbids direct `target +=` scoring, and replacing this expression with a built-in sampling statement would require a substantive likelihood rewrite. In particular, a `categorical_logit` rewrite over utterances would introduce a parameter-dependent normalization term because `state_bias` makes the summed mass over utterances equal to `sum_s state_prior[s] * exp(state_bias[s])`, which is not constant. Therefore the original posterior/log density cannot be preserved by a minor SafeStan translation.
