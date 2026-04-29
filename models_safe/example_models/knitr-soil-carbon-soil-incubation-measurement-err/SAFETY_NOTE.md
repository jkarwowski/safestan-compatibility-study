# SafeStan Safety Note

Compatibility: as-is.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed top-level data variable scored by a sampling statement is `eCO2mean`, and it is observed exactly once with a plain built-in sampling statement (`eCO2mean ~ normal(eCO2, eCO2sd)`). Other data variables are context inputs used for the ODE prediction, measurement standard deviations, sizes, or constants. Each top-level parameter has exactly one built-in prior or latent sampling statement before it is used in the model block.
