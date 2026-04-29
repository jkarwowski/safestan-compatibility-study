# SafeStan Safety Note

Compatibility: minor.

Protected data: `score_diff`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: `score_diff` is the only top-level data variable scored by a likelihood sampling statement, so it is the protected interface. The other data variables are context sizes, indices, and predictors and remain unprotected. Replaced `to_vector(eta_a) ~ normal(0,1);` with `eta_a ~ normal(0,1);` so the prior sampling statement targets the top-level parameter directly. This preserves the same elementwise standard normal prior density. No data fields or values were changed; `data_safe.json` is the supplied data.
