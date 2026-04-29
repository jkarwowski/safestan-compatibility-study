# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `theta ~ uniform(0, 1)` prior before the likelihood. This is density-neutral for `theta`, which is already constrained to `[0, 1]`, and satisfies SafeStan's requirement that each parameter have exactly one built-in prior before use. The likelihood remains `y ~ bernoulli(theta[z])`; `z`, `K`, and `N` are context data, not protected observations. No data changes were required.
