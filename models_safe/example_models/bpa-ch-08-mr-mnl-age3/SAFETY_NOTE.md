# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr_j`, `marr_a`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` prior sampling statements for `ssub`, `sad`, `rjuv`, and `rad`. These parameters are already constrained to `[0, 1]`, so these priors are density-neutral relative to the original implicit uniform priors and satisfy SafeStan's requirement that each parameter have exactly one built-in prior before likelihood use. The data file is unchanged.
