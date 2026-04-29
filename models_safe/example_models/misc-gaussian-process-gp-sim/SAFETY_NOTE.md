# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The data variables `N` and `x` are context inputs only; no top-level data variable appears on the left side of a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in `multi_normal` prior for the top-level parameter `y`, and the transformed data block uses only unprotected context data.
