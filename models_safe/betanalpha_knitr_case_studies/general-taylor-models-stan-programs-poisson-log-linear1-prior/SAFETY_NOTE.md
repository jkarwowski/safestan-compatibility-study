# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model contains no sampling statement for top-level data; `M`, `N`, `x0`, and `X` are context inputs only.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statements are built-in prior statements for the parameters `alpha` and `beta`, each appearing exactly once before any model-block use. No protected data interface is present.
