# SafeStan Safety Note

Compatibility: as-is.

Protected data: `s`, `h`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and are each observed exactly once with built-in sampling statements. `s` is observed before it is later used as the trial count in the likelihood for `h`; all other data variables are context inputs.
