# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood is implemented with manual `target += log_sum_exp(listener_lp)` scoring, where `listener_lp` depends on the protected observation through an index into `log_softmax(speaker_logits)`. SafeStan forbids direct `target +=` scoring. Replacing this with a built-in sampling statement such as a categorical likelihood would require a substantive rewrite of the marginalized pragmatic listener likelihood and would not preserve the same log density in general.
