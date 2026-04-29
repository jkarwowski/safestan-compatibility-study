# SafeStan Safety Note

Compatibility: minor.

Protected data: `M`, `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the transformed-data variable `Mv`, which was a pre-observation transform of protected data `M`. The `Y` likelihood now uses `to_vector(M)` directly after `M` has been observed in the model block. This is a same-density rewrite. `data_safe.json` is unchanged from the supplied data.
