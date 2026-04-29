# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program has no top-level data variable on the left side of a sampling statement; `w` and `z` are used as context inputs to construct Dirichlet hyperparameters in `transformed data`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the two parameter-prior loops were replaced by vectorized built-in Dirichlet sampling statements, so each top-level parameter variable is given exactly one prior outside control flow with a plain top-level left-hand side. No data values were changed.
