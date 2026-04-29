# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` prior sampling statements for `sigma_proc` and `sigma_obs`. These are density-neutral because both parameters are already constrained to `[0, 1]`, and they satisfy SafeStan's requirement that every parameter have exactly one built-in prior sampling statement before use. The data file is unchanged. `T` and `pyears` are context/configuration inputs, not protected observations.
