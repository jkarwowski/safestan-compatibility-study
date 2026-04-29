# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The Stan program does not observe/score any top-level data variable with a sampling statement; all data variables are context/configuration inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the prior on the transformed parameter `beta_sex = [beta_sex_raw, -beta_sex_raw]'` as a direct prior on the top-level parameter `beta_sex_raw`. The original `beta_sex ~ std_normal()` contributes the same parameter-dependent log density as `beta_sex_raw ~ normal(0, 1 / sqrt(2))`. The sigma hyperpriors were moved before the hierarchical priors that use them, satisfying SafeStan's parameter use-before-prior rule. No data fields were added or changed.
