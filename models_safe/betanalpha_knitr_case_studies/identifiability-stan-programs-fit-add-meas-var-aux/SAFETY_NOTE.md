# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_aux`, `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. Both protected observations are top-level data variables and are each observed exactly once with plain built-in sampling statements. All parameters have exactly one built-in prior before use.
