# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data and are scored by the plain vectorized sampling statement `y ~ bernoulli(theta)`. The parameter `theta` has an explicit proper prior before the likelihood.
