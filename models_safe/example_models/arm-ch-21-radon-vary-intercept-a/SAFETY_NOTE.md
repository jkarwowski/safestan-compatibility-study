# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the unused parameter `beta`. It is not referenced in transformed parameters or in the model block and contributes no log-density term, but SafeStan requires every top-level parameter to have exactly one built-in prior sampling statement. The protected likelihood for `y` and the log density over all retained parameters are unchanged. The data file is unchanged.
