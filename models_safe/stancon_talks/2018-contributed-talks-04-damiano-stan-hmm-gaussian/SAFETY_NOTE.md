# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model scores the observation sequence through a marginalized hidden Markov model forward algorithm, with the log likelihood added manually by `target += log_sum_exp(logalpha[T])`. The protected data `y` are also used in `transformed parameters` before any SafeStan observation statement. Replacing this with SafeStan-compatible built-in sampling statements would require a substantive likelihood/model rewrite rather than a mechanical same-density translation.
