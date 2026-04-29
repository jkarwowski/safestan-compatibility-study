# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood is implemented by manual `target += log_sum_exp(listener_lp)` scoring after marginalizing over listener states. SafeStan forbids arbitrary `target +=` scoring, and replacing this term with a built-in sampling statement such as a categorical likelihood would require a substantive likelihood rewrite and would not preserve the original log density.
