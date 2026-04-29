# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the row-wise multinomial likelihood was vectorized from `marr[t] ~ multinomial(pr[t])` inside a loop to the single protected-data statement `marr ~ multinomial(pr)`, so the protected variable is observed exactly once with a plain identifier. Added `marr_safestan_copy`, a deterministic copy of `marr`, because protected data cannot be read in `transformed data` before observation; the transformed-data release counts and generated-quantities observed fit statistic now use this copy. Added explicit `uniform(0, 1)` priors for `phi` and `p`, which are density-neutral for parameters already constrained to `[0, 1]` and satisfy SafeStan's unique-prior requirement.

Deterministic data augmentation: `marr_safestan_copy` is exactly equal to `marr` element-by-element.
