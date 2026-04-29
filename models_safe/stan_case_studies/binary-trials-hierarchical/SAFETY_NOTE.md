# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy of `y` (`y_safestan_copy[n] = y[n]` for every `n`), so transformed-data summaries do not read the protected observation before it is scored. Added `phi ~ uniform(0, 1)`, which is density-neutral for the existing finite-bounded parameter `real<lower=0, upper=1> phi`. Replaced the generated-quantities `binomial_lpmf` call for `log_p_new` with the equivalent binomial log-probability formula to avoid `_lp` calls; this does not affect the posterior density. The only variable to pass to `--sstan-protect` is `y`.
