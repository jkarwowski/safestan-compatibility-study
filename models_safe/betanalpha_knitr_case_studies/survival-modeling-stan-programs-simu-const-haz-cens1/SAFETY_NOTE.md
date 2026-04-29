# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model block sampling statement that observes top-level data, so all top-level data variables (`N`, `gamma`, `t1`, `t2`, `t3`) are context inputs for the simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no parameters, no likelihood sampling statements, and no direct `target` manipulation; the transformed-data simulation uses only context inputs.
