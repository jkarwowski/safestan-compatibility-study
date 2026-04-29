# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_calib`, `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. Both protected observations are top-level data variables and are each observed exactly once with a plain built-in sampling statement. The parameters `a`, `b`, and `sigma` each have exactly one built-in prior sampling statement before later use.
