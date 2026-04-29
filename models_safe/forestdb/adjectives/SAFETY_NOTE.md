# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance` is the data value conditioned on by the likelihood in the original model.

Generated files: none.

Reason: the likelihood is implemented with manual `target += log_sum_exp(listener_lp)` scoring for a marginalized listener/state calculation involving `observed_utterance`. SafeStan forbids `target +=` and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing the term with a built-in categorical sampling statement would change the density, because the original term includes a parameter-dependent unnormalized factor from `state_bias`. Preserving the original posterior would require a substantive model/density rewrite rather than a minor mechanical translation.
