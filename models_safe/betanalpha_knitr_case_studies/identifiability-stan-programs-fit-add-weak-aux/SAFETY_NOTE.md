# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_aux`, `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables, each is observed exactly once with a plain built-in sampling statement, and the parameters `a` and `b` each have exactly one built-in prior before use.
