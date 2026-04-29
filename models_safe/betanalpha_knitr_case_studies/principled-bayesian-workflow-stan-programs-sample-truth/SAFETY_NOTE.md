# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. `N` is a context/configuration input and is not scored by any likelihood statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood or parameter priors; it only uses `N` to size generated quantities and simulates data in `generated quantities`.
