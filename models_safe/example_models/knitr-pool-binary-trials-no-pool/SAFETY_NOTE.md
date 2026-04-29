# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, with `y_safestan_copy[n] = y[n]` for every `n`, because protected data cannot be read in `transformed data` before its observation. Added `theta ~ uniform(0, 1)`, which is density-neutral for the existing finite `[0, 1]` parameter constraint and satisfies SafeStan's unique-prior requirement. Replaced the generated-quantities `binomial_lpmf` call used to compute `log_p_new` with the equivalent binomial log-probability formula so the SafeStan file contains no `_lp` calls; this does not change the posterior.
