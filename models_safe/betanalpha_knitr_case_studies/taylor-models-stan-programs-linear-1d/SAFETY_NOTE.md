# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. The context inputs `x`, `x0`, `N`, `N_grid`, and `x_grid` are not protected because they are used only as predictors, sizes, or generated-quantity inputs. Each parameter has exactly one built-in prior before it is used in the likelihood.
