# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `data` block, no parameters, no `model` block likelihood, and no sampling statements conditioning on observed data. It is a prior/synthetic-data generator using `transformed data` and `generated quantities`, so there is no protected interface variable to score.
