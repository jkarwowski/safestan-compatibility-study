# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic construction of the local model-block variable `theta` until after the prior statement `baseline ~ normal(0, 8)`. This preserves the same posterior density while satisfying SafeStan's requirement that the parameter `baseline` receive its unique built-in prior before being used in the model block. No data fields were added or changed; the supplied JSON data is retained as-is.
