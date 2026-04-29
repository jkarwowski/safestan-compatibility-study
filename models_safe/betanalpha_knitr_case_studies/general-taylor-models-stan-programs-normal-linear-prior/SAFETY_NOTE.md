# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program does not condition on any top-level data variable with a sampling statement; `M`, `N`, `x0`, and `X` are context inputs only.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block contains only built-in prior sampling statements for the top-level parameters `alpha`, `beta`, and `sigma`, each exactly once, and there is no protected observed-data likelihood to rewrite.
