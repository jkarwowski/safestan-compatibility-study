# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The data variables `N1` and `N2` are context sizes used only to control generated-quantities simulation. No top-level data variable is scored by a sampling statement, and there are no parameters requiring priors.
