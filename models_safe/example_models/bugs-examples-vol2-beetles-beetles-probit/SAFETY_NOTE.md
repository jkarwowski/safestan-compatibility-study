# SafeStan Safety Note

Compatibility: as-is.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `r` is top-level data and is observed exactly once with the built-in statement `r ~ binomial(n, p);`. The other data variables (`N`, `n`, and `x`) are context inputs.
