# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model-block sampling statements and no parameters, so the top-level data variables (`theta_l`, `theta_u`, and `delta`) are context inputs rather than protected observations. The program does not use forbidden log-density editing constructs such as `target +=`, `target()`, `reject()`, `fatal_error()`, or `_lp` functions.
