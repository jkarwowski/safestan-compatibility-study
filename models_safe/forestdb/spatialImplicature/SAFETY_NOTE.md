# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observed utterance is scored through a manual `target += log_sum_exp(listener_lp)` likelihood after indexing `log_softmax(speaker_logits)[observed_utterance]`. SafeStan forbids arbitrary `target +=` scoring and requires the protected observation to appear exactly once on the left side of a built-in sampling statement. Replacing this expression with a built-in categorical likelihood would require a substantive rewrite of the marginalized listener calculation and, with `state_bias` included in the state weights, would change the parameter-dependent normalization and therefore the posterior density.
