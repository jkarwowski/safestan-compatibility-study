# SafeStan Safety Note

Compatibility: minor.

Protected data: `expression`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `expression_safestan_copy`, a deterministic copy of `expression`, because protected data cannot be read in `transformed data` before observation. Reordered the parameter prior sampling statements before the likelihood so each parameter is sampled before any model-block use through `predicted_expression`. Replaced the per-element observation loop with one vectorized truncated-normal sampling statement for the top-level protected variable `expression`; this preserves the same likelihood density.
