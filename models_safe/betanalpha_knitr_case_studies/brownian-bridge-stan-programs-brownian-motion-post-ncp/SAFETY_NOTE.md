# SafeStan Safety Note

Compatibility: as-is.

Protected data: `x_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `x_obs` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, after the parameter prior for `xs_forward_ncp`.
