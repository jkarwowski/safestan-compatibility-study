# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood for `observed_utterance` is implemented by manually accumulating `target += log_sum_exp(listener_lp)`, where `listener_lp` contains a marginalized latent-state calculation and indexes `log_softmax(speaker_logits)` by the observed utterance. SafeStan forbids `target +=`, and replacing this expression with a built-in sampling statement would require a substantive likelihood rewrite. In particular, a categorical rewrite would introduce a parameter-dependent normalization over utterances that is not present in the original target contribution. Therefore no minor same-density SafeStan translation is available.
