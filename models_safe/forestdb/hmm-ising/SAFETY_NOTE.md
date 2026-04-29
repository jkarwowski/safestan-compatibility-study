# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on `y` through a marginalized hidden-Markov forward recursion and then adds the likelihood with `target += log_sum_exp(forward[T])`. SafeStan forbids manual `target +=` scoring and requires each protected observation to be observed exactly once with a built-in sampling statement whose left side is the top-level protected variable. There is no minor same-density rewrite of this HMM marginal likelihood into SafeStan sampling statements; doing so would require a substantive likelihood/model rewrite.
