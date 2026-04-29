# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_std_1_safestan`, `y_std_2_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model computed `y_std = (y - mean(y)) / sd(y)` in `transformed data` and then scored that transformed-data quantity twice. SafeStan requires observed variables on the left side of sampling statements to be top-level protected data, and each protected variable may be scored exactly once. The safe model adds two top-level protected vectors, each a deterministic copy of the standardized response, and uses the two original normal likelihood terms once each. In `data_safe.json`, `y_std_1_safestan = y_std_2_safestan = (y - mean(y)) / sd(y)`, using Stan's sample standard deviation, computed from the supplied `y`. The original predictors `x` and `z` remain unprotected context inputs and their standardization is unchanged. Parameter priors are unchanged.
