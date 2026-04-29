# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on any top-level data with a likelihood sampling statement; `N`, `a`, `b`, `sigma`, and `x` are context inputs used only to simulate generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no parameters, no model-block likelihood, and no forbidden log-density manipulation; `y` is produced in `generated quantities` by `normal_rng` and is not an observed protected data variable.
