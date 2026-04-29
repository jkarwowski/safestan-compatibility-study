# SafeStan Safety Note

Compatibility: major.

Protected data: the response `y` is the modelled data conceptually, but the Stan likelihood is written for transformed data `y_std = (y - mean(y)) / sd(y)` rather than for a top-level data variable.

Generated files: none.

Reason: SafeStan requires each protected observation to be a top-level data variable appearing exactly once as a plain left-hand side of a built-in sampling statement. Here the sampling statement is `y_std ~ normal(mu_std, sigma_std)`, where `y_std` is computed in `transformed data` from `y` before any observation statement. Making this SafeStan-compatible without changing the density would require introducing the standardized response as an additional protected top-level data value, which is not a deterministic copy/reshape of the supplied data, or rewriting the likelihood on the original `y` scale, which changes the normalized likelihood by a data-scale Jacobian/additive constant. That is a substantive likelihood/interface change rather than a minor mechanical rewrite.
