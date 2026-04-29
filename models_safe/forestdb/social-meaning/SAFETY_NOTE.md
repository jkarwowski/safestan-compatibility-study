# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance` is the observed utterance index whose likelihood is scored in the model block. The remaining top-level data variables (`S`, `U`, `Q`, `state_prior`, `qud_weight`, `semantics`, and `utility`) are context/configuration inputs.

Generated files: none.

Reason: the likelihood is implemented with `target += log_sum_exp(listener_lp)`, manually marginalizing over latent states and using `observed_utterance` inside the computed log probability. SafeStan forbids `target +=`, and replacing this term with a built-in categorical sampling statement would normalize the utterance probabilities and change the density because the original expression includes a parameter-dependent unnormalized state-bias factor. Preserving the original posterior would therefore require a substantive likelihood rewrite rather than a minor SafeStan translation.
