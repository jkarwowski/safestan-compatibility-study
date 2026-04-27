# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_failures`, a deterministic shifted copy of the original observed `y` with `y_failures[n] = y[n] - 1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic shift from `transformed data` into `data_safe.json` as the added top-level field `y_failures`, because protected observations should not be derived in `transformed data` before observation. The likelihood is unchanged: `y_failures` is observed with the same plain `neg_binomial_2` sampling statement, and the existing `theta ~ beta(1, 1)` prior is preserved.
