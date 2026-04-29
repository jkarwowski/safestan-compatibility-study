# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi`, `B`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter prior sampling statements for `beta`, `gamma`, `xi`, and `delta` occur before any model-block computation that uses the ODE solution `y`, which depends on those parameters. The protected observations `stoi` and `B` remain top-level data variables and are each observed exactly once with built-in sampling statements. No data changes were required.
