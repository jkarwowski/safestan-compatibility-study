# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program does not condition on any top-level data variable with a sampling statement and has no parameters requiring priors; `N` and `gamma` are context inputs used only to simulate generated quantities.
