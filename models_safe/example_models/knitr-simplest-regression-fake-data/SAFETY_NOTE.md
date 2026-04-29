# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The Stan program has no model block, parameters, sampling statements, or manual target manipulation; it only generates simulated quantities from context data in `generated quantities`. Therefore there is no protected observed likelihood interface for this program.
