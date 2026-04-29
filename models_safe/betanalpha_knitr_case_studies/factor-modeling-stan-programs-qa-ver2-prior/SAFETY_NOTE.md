# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the prior statements for `delta_main_tau` and `delta_inter1_tau` so that each parameter is sampled before it is used as an argument in another parameter's prior. This preserves the same posterior/log density because the model block contributions are additive and the sampling statements are all built-in distributions. No data changes were made.
