# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for the bounded parameters `sigma_a` and `sigma_y`. These parameters already had finite bounds and no explicit prior in the original Stan program, corresponding to implicit uniform priors on the constrained scale. The added sampling statements satisfy SafeStan's requirement that every parameter have exactly one built-in prior before use. No data changes were required.
