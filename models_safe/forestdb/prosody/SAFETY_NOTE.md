# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observed utterance is conditioned on through a marginalized listener calculation implemented with `target += log_sum_exp(listener_lp)`. SafeStan forbids direct `target +=` scoring and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this term with a SafeStan-compatible sampling statement would require a substantive likelihood rewrite; in particular, the current expression is a manual marginalized log-weight involving latent state summation and `state_bias`, not a plain built-in observation statement preserving the same density.
