# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `marr_safestan_copy`, a deterministic copy of `marr`, because protected data are used in `transformed data` to compute release totals before the likelihood observation. The protected likelihood was changed from a loop over indexed rows, `marr[t] ~ multinomial(pr[t])`, to the equivalent vectorized built-in statement `marr ~ multinomial(pr)` so that the protected variable appears exactly once on the left side as a plain top-level identifier. Added explicit `uniform(0, 1)` priors for `phi` and `p`, which are density-neutral for parameters already constrained to `[0, 1]` and satisfy SafeStan's unique-prior requirement. Generated-quantities fit calculations read the deterministic copy of `marr`.

Deterministic data augmentation: `marr_safestan_copy` is exactly equal to `marr` from the supplied data.
