# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `mean_s ~ uniform(0, 1)` and `mean_r ~ uniform(0, 1)` priors, which are density-neutral for parameters already constrained to `[0, 1]`. Replaced the loop of indexed multinomial observation statements with the equivalent vectorized built-in statement `marr ~ multinomial(pr)`, so the protected top-level data variable is observed exactly once outside control flow. No data fields were added; `data_safe.json` is identical to the supplied data.
