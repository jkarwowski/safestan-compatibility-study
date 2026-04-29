# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block, no model block sampling statements, and no parameters requiring priors. The generated quantities simulate ordinal data but do not condition on any protected interface variable.
