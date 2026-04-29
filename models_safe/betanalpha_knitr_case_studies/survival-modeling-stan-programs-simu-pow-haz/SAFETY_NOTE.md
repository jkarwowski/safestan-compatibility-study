# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The Stan program has no model block likelihood and no parameter priors to check; all top-level data variables (`N`, `alpha`, and `sigma`) are context inputs used only to generate simulated quantities.
