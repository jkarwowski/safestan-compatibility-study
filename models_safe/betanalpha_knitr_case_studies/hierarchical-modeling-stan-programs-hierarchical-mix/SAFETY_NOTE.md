# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level variable `y`, which is observed exactly once with a built-in `normal` distribution and a plain identifier on the left-hand side. The remaining data variables are context inputs. Each parameter has exactly one built-in prior sampling statement before the transformed parameter depending on it is used in the likelihood.
