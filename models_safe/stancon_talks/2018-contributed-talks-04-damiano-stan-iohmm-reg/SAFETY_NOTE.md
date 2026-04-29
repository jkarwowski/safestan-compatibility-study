# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood for `y` is computed inside `transformed parameters` using `normal_lpdf`, then marginalized over hidden states with a forward algorithm and added manually via `target += log_sum_exp(logalpha[T])`. SafeStan forbids manual `target +=` scoring and protected data cannot be read in transformed parameters before a top-level sampling statement. Replacing this with SafeStan sampling statements would require a substantive rewrite of the marginalized hidden-state model rather than a minor same-density translation.
