# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance` is the data value used by the likelihood-like scoring expression. The remaining data variables are sizes or context inputs.

Generated files: none.

Reason: the model scores `observed_utterance` using `target += log_sum_exp(listener_lp)`, a manually marginalized latent-state likelihood. SafeStan forbids direct `target +=` scoring. Replacing this with a built-in categorical sampling statement would require adding a normalization term over utterances; because `state_bias` affects that normalizer, this would change the posterior/log density. Therefore an equivalent SafeStan rewrite is not a minor mechanical change.
