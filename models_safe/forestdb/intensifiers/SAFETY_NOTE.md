# SafeStan Safety Note

Compatibility: major.

Protected data: `observed_utterance`.

Generated files: none.

Reason: the observed utterance is scored through a manually accumulated marginalized likelihood, `target += log_sum_exp(listener_lp)`. SafeStan forbids arbitrary `target +=` scoring, and replacing this term with a SafeStan sampling statement would require a substantive model rewrite. In particular, the marginalized listener score includes unnormalized `state_bias` factors, so a simple categorical/categorical-logit observation would introduce a parameter-dependent normalization change and would not preserve the original posterior density.
