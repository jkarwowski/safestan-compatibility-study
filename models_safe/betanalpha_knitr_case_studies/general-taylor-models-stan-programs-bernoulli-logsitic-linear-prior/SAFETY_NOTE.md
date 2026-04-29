# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program does not score any top-level data variables; `M`, `N`, `x0`, and `X` are context inputs only. Each parameter is given exactly one built-in prior sampling statement in the model block before any model-block use, and no forbidden direct log-density manipulation is present.
