# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no parameters, and no sampling statements conditioning on data. `N1` and `N2` are context inputs used only as sizes for generated quantities, not protected observations.
