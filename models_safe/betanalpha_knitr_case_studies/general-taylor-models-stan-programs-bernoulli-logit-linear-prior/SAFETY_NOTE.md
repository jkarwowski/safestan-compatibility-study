# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no observed data likelihood: `M`, `N`, `x0`, and `X` are context inputs used for deterministic transformed data and posterior predictive simulation only. The parameters `alpha` and `beta` each have exactly one built-in prior sampling statement before any model-block use.
