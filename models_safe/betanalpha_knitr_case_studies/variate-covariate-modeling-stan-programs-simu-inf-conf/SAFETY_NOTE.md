# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program does not condition on any observed data with sampling statements; `N1` and `N2` are context inputs used only for sizing generated quantities. There are no parameters requiring priors and no protected observations.
