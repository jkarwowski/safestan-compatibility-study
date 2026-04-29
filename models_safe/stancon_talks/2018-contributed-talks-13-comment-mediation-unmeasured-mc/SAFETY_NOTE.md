# SafeStan Safety Note

Compatibility: major.

Protected data: `M` and `Y`.

Generated files: none.

Reason: the likelihood for the observed mediator and outcome is implemented with manual `target += log_sum_exp(...)` scoring that marginalizes over an unobserved binary confounder `U`. SafeStan forbids direct `target +=` scoring, and this marginalized joint likelihood cannot be expressed as a minor same-density rewrite using only built-in Stan sampling statements on top-level protected data variables. Replacing it would require a substantive model rewrite or a custom/user-defined likelihood, which is outside the SafeStan-compatible subset.
