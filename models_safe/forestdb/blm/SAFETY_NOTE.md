# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observation likelihood for `observed_utterance` is implemented by manual `target += log_sum_exp(listener_lp)` scoring after marginalizing over latent states. SafeStan forbids `target +=`, and replacing this term with a built-in sampling statement would change the density because the existing term is not simply a normalized built-in categorical likelihood over utterances. A SafeStan translation would require a substantive likelihood/model rewrite rather than a minor mechanical change.
