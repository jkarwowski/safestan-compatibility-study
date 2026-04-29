# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added the explicit prior `d ~ uniform(2, 100);` before the likelihood. This matches the parameter's existing finite bounds and is density-neutral up to a constant for the original constrained parameter, while satisfying SafeStan's requirement that each parameter have exactly one built-in prior sampling statement before use. The data file is unchanged.
