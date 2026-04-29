# SafeStan Safety Note

Compatibility: major.

Protected data: candidate protected observation is `observed_utterance`.

Generated files: none.

Reason: the model scores `observed_utterance` through a manually marginalized likelihood, `target += log_sum_exp(listener_lp)`, where `listener_lp` depends on latent parameters and `log_softmax(...)[observed_utterance]`. SafeStan forbids direct `target +=` scoring and requires protected observations to be scored exactly once as the plain left-hand side of a built-in sampling statement. Replacing this marginalized listener/speaker calculation with a built-in sampling distribution would be a substantive likelihood rewrite and would not be a minor same-density translation.
