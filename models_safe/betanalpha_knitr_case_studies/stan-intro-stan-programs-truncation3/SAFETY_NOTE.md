# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += normal_lpdf(x | 0, 1)` prior contribution with the equivalent built-in sampling statement `x ~ normal(0, 1)`. No data variables are observed or protected, and `data_safe.json` is unchanged.
