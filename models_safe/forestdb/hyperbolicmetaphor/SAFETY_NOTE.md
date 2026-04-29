# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the model conditions on `observed_utterance` through a manually accumulated marginalized likelihood, `target += log_sum_exp(listener_lp)`. SafeStan forbids direct `target +=` scoring, and replacing this term with a built-in categorical sampling statement would change the density: a normalized categorical/logit likelihood would introduce a parameter-dependent normalizer, while the original expression uses unnormalized state weights involving `state_bias`. Preserving the posterior would therefore require a substantive likelihood rewrite rather than a minor mechanical SafeStan translation.
