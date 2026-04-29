# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation is scored through a marginalized finite-state likelihood implemented with manual `target += log_sum_exp(listener_lp)`. SafeStan forbids arbitrary `target +=` scoring, and replacing this expression with a built-in sampling statement would require a substantive likelihood rewrite. In particular, a categorical rewrite would introduce a normalization over utterances that is not present in the original target density when `state_bias` is free, so it would not preserve the original posterior/log density.
