# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so each parameter prior is declared before any model-block use of that parameter, including the use of `tau` through `sigma`. The likelihood `Y ~ normal(m, sigma)` remains a single built-in sampling statement for the top-level protected data variable. `N` and `x` are context inputs. No data fields were added or changed.
