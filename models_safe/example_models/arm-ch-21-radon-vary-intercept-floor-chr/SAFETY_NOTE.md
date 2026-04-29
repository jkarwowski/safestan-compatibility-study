# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for the bounded parameters `sigma_a` and `sigma_y`. These match the parameters' existing finite constraints and are density-neutral in Stan's proportional sampling notation, while satisfying SafeStan's requirement that every parameter have exactly one built-in prior before use. No data fields were added or changed.
