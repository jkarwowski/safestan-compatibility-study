# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no top-level data variables to protect; `W` is a top-level parameter with exactly one built-in prior sampling statement, `W ~ wishart(4, S)`, before any model-block use.
