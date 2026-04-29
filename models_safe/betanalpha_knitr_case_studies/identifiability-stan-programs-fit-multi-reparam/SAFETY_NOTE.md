# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. `N` and `sigma` are context inputs, and the parameter `a_times_b` has exactly one built-in prior before it is used in the likelihood.
