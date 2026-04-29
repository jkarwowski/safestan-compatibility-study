# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is top-level data variable `y`, and it appears exactly once on the left side of a built-in distribution statement. All top-level parameters have exactly one built-in prior sampling statement before their model-block use through `y_hat`.
