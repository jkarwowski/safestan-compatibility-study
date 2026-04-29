# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block sampling statements and no parameters, so the top-level data variables (`theta_l`, `theta_u`, and `delta`) are context inputs rather than protected observations. The model does not use `target +=`, `_lp` functions, `reject()`, or other SafeStan-forbidden likelihood-editing constructs.
