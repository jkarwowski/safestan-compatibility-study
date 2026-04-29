# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter prior sampling statements so that `tau` is given its prior before it is used in the prior for `theta`. This is a density-preserving mechanical change because Stan sampling statements add log-density terms commutatively. No data changes were required.
