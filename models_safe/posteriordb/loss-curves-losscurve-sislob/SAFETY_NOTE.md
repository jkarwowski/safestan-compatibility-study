# SafeStan Safety Note

Compatibility: as-is.

Protected data: `loss`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level variable `loss`, and it is observed exactly once with a plain built-in `normal` sampling statement. All parameters have exactly one built-in prior before they are used in the model likelihood, and the program does not use forbidden direct log-density manipulation constructs.
