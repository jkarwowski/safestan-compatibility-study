# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The remaining data variables (`N`, `K`, `sigma`, and `indiv_idx`) are context inputs used as sizes, indices, or known measurement variability. Each parameter (`mu`, `tau`, and `eta`) has exactly one built-in prior sampling statement before the transformed parameter `theta` is used in the observational model.
