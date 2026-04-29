# SafeStan Safety Note

Compatibility: major.

Protected data: `Y` is the observed response scored by the likelihood; `x` and `N` are context inputs.

Generated files: none.

Reason: the likelihood is a marginalized changepoint mixture implemented with manual `target += log_sum_exp(...)` scoring, with component log densities computed using `normal_lpdf(Y | mu, sigma)`. SafeStan forbids direct target manipulation and requires protected observations to be scored exactly once by a built-in sampling statement. Replacing this marginalized mixture with SafeStan-compatible sampling statements would require a substantive model rewrite or a different likelihood representation, so no minor same-density translation is available.
