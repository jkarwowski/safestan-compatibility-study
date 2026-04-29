# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in priors `sigma_a ~ uniform(0, 100)` and `sigma_y ~ uniform(0, 100)` for parameters that were already finitely constrained to `[0, 100]`. This makes the implicit bounded flat priors explicit so every parameter has exactly one SafeStan prior sampling statement before the protected likelihood. No data fields were added or changed.
