# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no `data` block and no observed data variables scored by a likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains deterministic transformed-data calculations and generated quantities only; there are no protected observations, parameters, sampling statements, or direct target manipulations.
