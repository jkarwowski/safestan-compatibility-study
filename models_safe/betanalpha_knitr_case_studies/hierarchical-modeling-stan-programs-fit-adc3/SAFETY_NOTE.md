# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic model-block helper computation for `log_psi` out of the beginning of the model block by inlining the equivalent expression in the observation statement. This preserves the same density while ensuring parameters are first used only after their prior sampling statements. No data changes were made; all other data variables are context inputs.
