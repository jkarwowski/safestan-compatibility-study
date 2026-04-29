# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not score any top-level data variable with a sampling statement; all data variables (`M`, `N`, `x0`, and `X`) are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model contains only built-in prior sampling statements for the parameters (`alpha`, `beta`, and `sigma`), each parameter is sampled exactly once before any model-block use, and there are no protected observations, manual `target` updates, `_lp` functions, or other SafeStan-forbidden constructs.
