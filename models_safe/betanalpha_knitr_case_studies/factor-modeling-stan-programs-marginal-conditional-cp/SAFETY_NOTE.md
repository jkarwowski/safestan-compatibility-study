# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior sampling statements so that each parameter is sampled before it is used by another prior or by the likelihood. This is a mechanical same-density change because the model log density is a sum of the same built-in distribution terms. No data fields were added or changed.
