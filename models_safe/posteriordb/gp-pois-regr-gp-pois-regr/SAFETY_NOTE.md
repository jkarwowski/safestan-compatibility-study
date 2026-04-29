# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `k` is a top-level data variable and is observed exactly once with a plain built-in sampling statement (`k ~ poisson_log(f)`) after all parameters used through `f` have received their priors. The remaining data variables `N` and `x` are context inputs used for sizes and covariance construction, not protected observations.
