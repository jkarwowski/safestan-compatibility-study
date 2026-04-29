# SafeStan Safety Note

Compatibility: major.

Protected data choice: the original likelihood scores the observed matrix `y`. The other declared data variables (`n1`, `n2`, and `x1`) are sizes or covariates/context inputs.

Generated files: none.

Reason: the likelihood for `y` is implemented by a custom Kronecker/eigendecomposition Gaussian-process marginal log density using `target +=`. SafeStan forbids arbitrary `target +=` scoring and requires the protected observation to be scored exactly once by a built-in distribution. Replacing this hand-coded Kronecker marginal likelihood with a built-in multivariate-normal statement would require a substantive algebraic/algorithmic rewrite of the GP likelihood and a deterministic reshape of the matrix observation, which is beyond a minor mechanical SafeStan translation.
