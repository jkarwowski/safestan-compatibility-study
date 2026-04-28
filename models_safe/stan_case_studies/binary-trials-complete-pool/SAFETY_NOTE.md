# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because protected data cannot be read in `transformed data` before its observation statement. Added `phi ~ uniform(0, 1)`, which is density-neutral for the already constrained parameter `phi` and satisfies SafeStan's unique-prior requirement. Replaced the generated-quantities call to `binomial_lpmf` with the algebraically equivalent binomial log-probability formula to avoid direct `_lp` function calls. These changes preserve the posterior/log density for the protected likelihood `y ~ binomial(K, phi)`.
