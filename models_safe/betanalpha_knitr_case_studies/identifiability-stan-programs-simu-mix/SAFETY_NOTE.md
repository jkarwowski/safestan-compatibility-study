# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model-block likelihood and no top-level data variable is conditioned on with a sampling statement. `N` is a context input used only to size generated quantities.
