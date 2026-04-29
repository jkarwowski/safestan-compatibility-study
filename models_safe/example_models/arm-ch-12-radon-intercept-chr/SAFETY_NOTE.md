# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior statements so that `sigma_a` is observed with its prior before being used as the scale in the prior for `alpha`. This preserves the same posterior density because the order of independent log-density additions in the model block is immaterial. No data changes were required; `N`, `J`, and `county` remain context inputs, and `y` is the only protected observed variable.
