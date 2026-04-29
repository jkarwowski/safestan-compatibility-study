# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The remaining data variables, `N` and `sigma_y`, are context inputs. Each top-level parameter has exactly one built-in prior sampling statement before the protected likelihood is evaluated.
