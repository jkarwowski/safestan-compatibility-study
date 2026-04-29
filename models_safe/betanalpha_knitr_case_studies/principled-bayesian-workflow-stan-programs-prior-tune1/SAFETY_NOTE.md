# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no top-level data variables, no sampling statements, no parameters requiring priors, and no prohibited direct log-density manipulation. The transformed-data computation and generated quantity are deterministic and do not condition on protected data.
