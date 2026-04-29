# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The context inputs `N` and `sigma` are not protected. Parameters `a` and `b` each have exactly one built-in prior before they are used in the observational model.
