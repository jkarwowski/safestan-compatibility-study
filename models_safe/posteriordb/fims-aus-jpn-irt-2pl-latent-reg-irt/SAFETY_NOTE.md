# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual prior contribution `target += normal_lpdf(beta | 0, 3)` with a built-in sampling statement `beta ~ normal(0, 3)`. To make this SafeStan-compatible, `beta` is declared as a top-level `sum_to_zero_vector[I]` parameter and the former `beta_free` parameter plus deterministic transformed-parameter construction are removed. This preserves the intended sum-to-zero item-difficulty parameterization and avoids arbitrary `target +=` scoring. No data changes were made.
