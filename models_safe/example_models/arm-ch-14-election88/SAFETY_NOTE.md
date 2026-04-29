# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added an explicit `sigma_a ~ uniform(0, 100)` prior for the already bounded parameter `sigma_a`. This is density-neutral for the original model because `sigma_a` was constrained to `[0, 100]` and otherwise had the corresponding implicit flat density. The prior is placed before `sigma_a` is used in the prior for `a`, satisfying SafeStan's parameter-use ordering rule. No data changes were required.
