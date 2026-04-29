# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model-block sampling statements and no parameters, so no top-level data variable is conditioned on as an observation. `N_predict`, `f`, and `sigma` are context inputs used only to generate posterior/predictive quantities.
