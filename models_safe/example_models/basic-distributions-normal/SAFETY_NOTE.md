# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model has no top-level data variables and no observed-data likelihood; `y` is a parameter with a built-in normal prior.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The sole sampling statement assigns exactly one built-in prior to the top-level parameter `y`, and there are no protected observations to declare.
