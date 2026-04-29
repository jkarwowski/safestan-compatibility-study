# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The context input `N` is used only for sizing. Each parameter (`a`, `b`, and `sigma`) has exactly one built-in prior sampling statement before it is used in the likelihood.
