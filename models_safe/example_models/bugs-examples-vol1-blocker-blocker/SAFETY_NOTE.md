# SafeStan Safety Note

Compatibility: minor.

Protected data: `rt`, `rc`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that every parameter is given its built-in prior before any later model-block use through predictors or transformed parameters. The protected observations `rt` and `rc` remain top-level data variables and are each observed exactly once with plain built-in sampling statements. No data fields were added or changed.
