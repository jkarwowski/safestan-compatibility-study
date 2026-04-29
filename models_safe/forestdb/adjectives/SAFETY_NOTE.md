# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance` is the observed interface value used in the likelihood factor.

Generated files: none.

Reason: the model scores `observed_utterance` through a manually accumulated marginalized likelihood, `target += log_sum_exp(listener_lp)`. SafeStan forbids direct `target +=` scoring, and replacing this factor with a built-in categorical sampling statement would introduce a parameter-dependent normalization term because `state_bias` appears inside the marginalized weights. That would change the posterior/log density, so this is not a minor same-density rewrite.
