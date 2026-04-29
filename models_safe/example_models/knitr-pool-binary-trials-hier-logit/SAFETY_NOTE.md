# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because `y` is the protected likelihood observation and the original program read it in `transformed data` before its sampling statement. The transformed-data summaries and generated-quantities average check now use the copy; `y` remains observed exactly once by `y ~ binomial_logit(...)`. No statistical density was changed.

Deterministic data augmentation: `y_safestan_copy` equals `y` elementwise.
