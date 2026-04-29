# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood is implemented by manual `target += log_sum_exp(listener_lp)` scoring, where `listener_lp` depends on `observed_utterance` through an indexed `log_softmax` term. SafeStan forbids arbitrary `target +=` scoring. Replacing this with a built-in categorical sampling statement would introduce a parameter-dependent normalization term and would not preserve the original posterior/log density. An exact translation would require a custom likelihood or a substantive marginalized-latent-state rewrite, so this is not a minor SafeStan-compatible change.
