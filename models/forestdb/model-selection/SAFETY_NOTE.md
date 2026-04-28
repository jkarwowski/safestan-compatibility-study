# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is scored through manual `normal_lpdf` terms accumulated into two whole-data model log densities and combined with `target += log_sum_exp(...)`, marginalizing a discrete linear-vs-quadratic model indicator over the data set. This is mixture/model-selection marginalization with custom manual scoring of the protected observations. Replacing it with SafeStan plain sampling statements would require a substantive likelihood/model rewrite, not a minor same-density translation. The covariate `x` is data used in the likelihood predictors but is not itself scored as a protected observation.
