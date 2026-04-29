# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation is scored only through a manual `target += log_sum_exp(listener_lp)` marginalized likelihood. SafeStan forbids arbitrary `target +=` scoring, and replacing this term with a built-in categorical sampling statement would require adding a parameter-dependent normalization term, changing the posterior/log density. Therefore this model cannot be translated with only a minor same-density rewrite.
