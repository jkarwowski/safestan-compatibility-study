# SafeStan Safety Note

Compatibility: major.

Protected data choice: `observed_utterance` is the observed interface variable scored by the model. Other data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are context inputs, sizes, constants, or predictors.

Generated files: none.

Reason: the likelihood for `observed_utterance` is implemented with manual `target += log_sum_exp(listener_lp)` scoring after marginalizing over latent states. SafeStan forbids arbitrary `target +=` scoring and requires the protected observation to be scored exactly once by a built-in sampling statement. Replacing this term with a built-in categorical distribution would introduce a parameter-dependent normalization over utterances and would not preserve the original posterior/log density. A SafeStan translation would therefore require a substantive likelihood rewrite.
