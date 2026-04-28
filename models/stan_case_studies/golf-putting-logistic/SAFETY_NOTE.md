# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed with the plain vectorized sampling statement `y ~ binomial(n, p);`. The variables `n`, `x`, `r`, and `R` are data inputs used as likelihood arguments or covariates and are not themselves protected observations scored by the likelihood.
