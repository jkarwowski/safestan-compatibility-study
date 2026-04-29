# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed ordinal response `y` is scored by a built-in `ordered_logistic` likelihood, but the prior for parameter `c` is a user-defined distribution, `induced_dirichlet`, implemented by an `_lpdf` function. SafeStan rejects user-defined `_lp`/`_lpdf` functions and requires every parameter prior sampling statement to resolve to a built-in Stan distribution. Replacing this induced Dirichlet prior on ordered cut points with SafeStan-compatible built-in priors would change the prior density, so this is not a minor same-density translation.
