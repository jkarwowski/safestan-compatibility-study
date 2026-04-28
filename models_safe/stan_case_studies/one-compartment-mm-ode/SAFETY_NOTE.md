# SafeStan Safety Note

Compatibility: as-is.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `C` is a top-level data variable and is observed exactly once with a plain built-in sampling statement (`C ~ lognormal(...)`) before any other use. Parameters each have one built-in prior sampling statement before the likelihood uses them through `mu_C`.
