# SafeStan Safety Note

Compatibility: major.

Protected data choice: `observed_utterance` is the observed interface variable being scored by the model. The remaining data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are sizes, constants, or predictors/context inputs.

Generated files: none.

Reason: the likelihood for `observed_utterance` is implemented with manual `target += log_sum_exp(listener_lp)` scoring after marginalizing over listener states. SafeStan forbids arbitrary `target +=` scoring and requires the protected observation to be scored exactly once by a built-in distribution. Replacing this expression with a built-in categorical distribution would require normalizing over utterances, which would add a parameter-dependent normalization term involving `state_bias` and therefore change the posterior/log density. Thus a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
