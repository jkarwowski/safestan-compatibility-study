# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y1`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is top-level `y1`, and it is observed exactly once with the built-in `normal` distribution using a plain left-hand-side identifier. The remaining data variables (`N1`, `N2`, `x1`, and `x2`) are context inputs. Each parameter has exactly one built-in prior sampling statement before it is used in the model likelihood.
