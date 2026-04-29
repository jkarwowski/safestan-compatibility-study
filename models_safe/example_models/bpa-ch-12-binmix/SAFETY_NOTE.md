# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized binomial mixture implemented by manual `target += log_sum_exp(...)` scoring with `poisson_lpmf` and `binomial_lpmf` terms. SafeStan forbids arbitrary `target +=` scoring, and replacing this finite marginalization with SafeStan sampling statements would require a substantive model rewrite rather than a mechanical same-density translation.
