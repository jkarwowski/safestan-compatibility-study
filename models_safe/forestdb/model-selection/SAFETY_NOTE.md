# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (with `x` as an unprotected predictor/context input).

Generated files: none.

Reason: the likelihood for `y` is a marginalized model-selection mixture over the entire data set, implemented by accumulating `normal_lpdf` terms into two log probabilities and then using `target += log_sum_exp(lp_linear, lp_quad)`. SafeStan forbids arbitrary `target +=` scoring and `_lpdf` calls, and this global marginalized mixture cannot be expressed as a single built-in sampling statement on a top-level protected variable without a substantive model rewrite or likelihood change.
