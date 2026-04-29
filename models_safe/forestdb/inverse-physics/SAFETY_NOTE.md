# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is top-level data and is observed exactly once with a plain built-in sampling statement after both parameters have their built-in priors.
