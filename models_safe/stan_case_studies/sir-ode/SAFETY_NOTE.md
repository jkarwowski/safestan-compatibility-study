# SafeStan Safety Note

Compatibility: minor.

Protected data: `stoi`, `B`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that all parameter priors are sampled before any model-block use of parameter-dependent transformed quantities (`y` and `y_diff`). The protected observations are still scored exactly once using the original built-in likelihood statements: `stoi ~ poisson(y_diff)` and `B ~ lognormal(log(y[ : , 4]), 0.15)`. The data file is unchanged and no fields were added.
