# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The data variables `M`, `N`, `x0`, and `X` are context inputs only; no top-level data variable is conditioned on with a sampling statement in the model block.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model contains only built-in prior sampling statements for the top-level parameters, each parameter is sampled exactly once before any model-block use, and there is no arbitrary `target +=` scoring or protected observation to rewrite.
