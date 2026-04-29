# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite mixture implemented with manual `target += log_sum_exp(...)` scoring and a user-defined Dirichlet-multinomial log PMF. SafeStan forbids arbitrary `target +=` likelihood construction and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this marginalized mixture with SafeStan sampling statements would require a substantive model rewrite or a change to the likelihood representation, so no minor same-density translation is provided.
