# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once by the built-in statement `y ~ normal(theta[context_idx], sigma);` after the parameter `theta` has its built-in prior `theta ~ normal(0, 0.1);`. The remaining data variables `K`, `N`, `context_idx`, and `sigma` are context inputs and are not observed on the left side of a sampling statement.
