# SafeStan Safety Note

Compatibility: major.

Protected data choice: `observed_utterance` is the data value conditioned on by the model. The other data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are context inputs.

Generated files: none.

Reason: the likelihood for `observed_utterance` is implemented with a manual `target += log_sum_exp(listener_lp)` marginalized over latent states. SafeStan forbids arbitrary `target +=` scoring. Replacing this with a built-in categorical sampling statement would require constructing a normalized utterance distribution and would change the posterior, because the original expression includes unnormalized state-bias weights. This is therefore not a minor same-density rewrite.
