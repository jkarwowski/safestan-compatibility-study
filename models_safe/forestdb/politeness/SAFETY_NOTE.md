# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation is scored through a manually accumulated marginalized likelihood, `target += log_sum_exp(listener_lp)`, where `listener_lp` depends on `observed_utterance` through an indexed `log_softmax` term. SafeStan forbids `target +=` and requires protected observations to be scored exactly once by a built-in sampling statement with the protected variable on the left-hand side. Replacing this expression with a built-in categorical sampling statement would require a substantive likelihood rewrite and, in general, would introduce a parameter-dependent normalization term not present in the original density. Therefore this model is not SafeStan-compatible by a minor same-density translation.
