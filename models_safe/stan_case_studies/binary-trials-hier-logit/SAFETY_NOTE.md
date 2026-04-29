# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy of `y` with `y_safestan_copy[n] = y[n]` for all `n`. The copy is used for transformed-data summaries and the generated-quantity season-average check so the protected observation `y` is only observed by the single built-in likelihood statement `y ~ binomial_logit(...)`. The priors for `mu`, `sigma`, and `alpha_std` were already explicit built-in sampling statements and are left unchanged.
