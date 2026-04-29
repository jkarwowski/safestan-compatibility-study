# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance` is the observed interface variable, because the model conditions on it inside the manual likelihood calculation. The remaining data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are context inputs, sizes, constants, or unused context.

Generated files: none.

Reason: the likelihood is implemented with `target += log_sum_exp(listener_lp)`, where `listener_lp` contains `log_softmax(speaker_logits)[observed_utterance]`. SafeStan forbids manual `target +=` scoring, and replacing this marginalized listener calculation with a built-in sampling statement would be a substantive likelihood rewrite. In particular, a normalized categorical rewrite would introduce a parameter-dependent normalizer involving `state_bias`, so it would not preserve the original posterior density.
