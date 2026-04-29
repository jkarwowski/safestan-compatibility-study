# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior statements so `delta_factor_tau` is sampled before it is used as the scale in the prior for `delta_factor_cp`. This preserves the same joint density because the product of prior factors is unchanged. No data changes were required.
