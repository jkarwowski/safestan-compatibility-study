# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on or score any top-level data variable; all inputs are context/configuration used for prior/predictive simulation in `generated quantities`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The Stan program has no `model` block, no parameters, no sampling statements, and no manual target manipulation, so there is no protected likelihood interface to enforce.
