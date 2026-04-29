# SafeStan Safety Note

Compatibility: major.

Protected data choice: `observed_utterance` is the observed interface variable scored by the model. The other data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are sizes, constants, or context inputs rather than observed likelihood targets.

Generated files: none.

Reason: the likelihood for `observed_utterance` is implemented with manual `target += log_sum_exp(listener_lp)` scoring after marginalizing over latent states. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by a built-in distribution. Replacing this term with a built-in categorical distribution would require normalizing over utterances, which would add a parameter-dependent normalization term because `state_bias` is unconstrained. That would change the posterior/log density. Therefore this is not a minor same-density translation.
