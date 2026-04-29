# SafeStan Safety Note

Compatibility: minor.

Protected data: `pos_tests`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so every top-level parameter is given its built-in prior before any likelihood use through `prob_pos_test`. Replaced the transformed-parameter prior `beta_sex ~ std_normal()` with the equivalent top-level prior `beta_sex_raw ~ normal(0, 0.7071067811865476)`, since `beta_sex = [beta_sex_raw, -beta_sex_raw]` contributes `-beta_sex_raw^2` to the Stan target. The protected likelihood remains `pos_tests ~ binomial(tests, prob_pos_test)`. No data changes were made.
