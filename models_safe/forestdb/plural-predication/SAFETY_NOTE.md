# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model conditions on `observed_utterance` through the manually accumulated listener likelihood.

Generated files: none.

Reason: the likelihood for `observed_utterance` is implemented as `target += log_sum_exp(listener_lp)`, where `listener_lp` marginalizes over latent listener states and includes parameter-dependent state weights. SafeStan forbids `target +=`, and replacing this expression with a built-in sampling statement would require a substantive likelihood rewrite. In particular, a categorical rewrite would introduce a parameter-dependent normalization term that is not present in the original density, so it would not preserve the posterior/log density.
