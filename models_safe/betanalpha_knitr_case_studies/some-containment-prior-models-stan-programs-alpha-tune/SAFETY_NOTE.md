# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model block sampling statements and no observed data likelihood; `theta_l` and `theta_u` are context inputs used deterministically in transformed data and generated quantities, not protected observations.
