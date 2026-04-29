# SafeStan Safety Note

Compatibility: minor.

Protected data: `y1`, `x1`, and `y2`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that every parameter receives its original built-in prior before the parameter is used in deterministic computations or likelihood terms. The deterministic variance computations were moved into a local block after the priors. No data variables were added or modified; `data_safe.json` is the supplied data. The protected observations remain top-level data and are each observed exactly once with built-in `normal` sampling statements. `y1` is observed before it is used as a predictor in the likelihood for `x1`.
