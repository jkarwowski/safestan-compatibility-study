# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable is `N`, which is a context/input size and is not observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood or parameter priors; it is a generated-quantities prior predictive simulator using `N` only as configuration.
