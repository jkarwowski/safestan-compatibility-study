# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: kept `y` as the only protected observation and moved all parameter priors before the likelihood so no parameter is used before its prior. Replaced the manual ICAR `target += -0.5 * dot_self(...)` term with a built-in `multi_normal_prec` prior for the top-level parameter `phi_raw`; the precision matrix is computed deterministically in `transformed data` as B'B, where B maps `phi_raw` to the neighbor edge differences used in the original penalty. Replaced the explicit transformed-data `reject` check with a constrained transformed-data declaration for `N_singletons`; this enforces the same valid input condition without `reject`. No fields were added to `data_safe.json`.
