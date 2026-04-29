# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program has no data block and no observed likelihood terms.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in uniform priors for `x_raw` and `y_raw`, matching their finite parameter constraints. This is density-neutral up to the same constant on the constrained support and satisfies SafeStan's requirement that every parameter have exactly one built-in prior sampling statement before use. The data file remains the empty JSON object.
