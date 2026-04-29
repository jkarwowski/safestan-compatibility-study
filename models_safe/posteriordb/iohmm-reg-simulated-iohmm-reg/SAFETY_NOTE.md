# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood for `y` is embedded in a marginalized hidden-state forward algorithm. The model computes `normal_lpdf(y[t] | ...)` in `transformed parameters`, stores those values in `logoblik`, propagates them through `logalpha`, and then scores the marginal likelihood with `target += log_sum_exp(logalpha[T])`. SafeStan forbids manual `target +=` scoring and requires each protected observation to be scored exactly once by a built-in sampling statement before any other use. Replacing this forward-algorithm marginal likelihood with SafeStan sampling statements would require a substantive model rewrite, not a minor same-density translation.
