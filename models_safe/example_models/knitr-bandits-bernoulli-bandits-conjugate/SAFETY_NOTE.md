# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program contains no `model` block and no sampling statements that observe top-level data, so no data variable is part of a SafeStan protected likelihood interface.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All top-level data variables are treated as context inputs used to compute deterministic sufficient statistics in `transformed data` and posterior draws in `generated quantities`; there are no parameters, priors, protected observations, or forbidden log-density edits.
