# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only data variable observed with a sampling statement is the top-level variable `y`, and it is observed exactly once with the built-in `normal` distribution. The other data variables (`N`, `N_pred`, `x`, `x_pred`, and `zeros`) are context/configuration inputs and are not protected. Each parameter has exactly one built-in prior sampling statement before the likelihood uses transformed quantities depending on it.
