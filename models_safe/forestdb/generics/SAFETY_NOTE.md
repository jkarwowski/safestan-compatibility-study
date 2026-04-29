# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model conditions on `observed_utterance`; it would be the protected interface variable in a SafeStan translation.

Generated files: none.

Reason: the likelihood is implemented with `target += log_sum_exp(listener_lp)`, marginalizing over latent listener states with custom unnormalized weights involving `state_bias`. SafeStan forbids `target +=`, and replacing this term by a built-in sampling statement such as `categorical_logit` would add a parameter-dependent normalization not present in the original density. Preserving the exact posterior would require a substantive custom factorization or auxiliary likelihood correction, not a minor mechanical rewrite.
