# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation matrix `y` is scored only through a custom `target +=` Kronecker Gaussian-process marginal likelihood involving eigendecompositions and user-defined matrix operations. SafeStan forbids arbitrary `target +=` scoring, and replacing this expression with a built-in distribution would require a substantive likelihood-algorithm rewrite, including deriving a dense multivariate-normal covariance and reshaping the protected observation. That is not a minor mechanical SafeStan translation.
