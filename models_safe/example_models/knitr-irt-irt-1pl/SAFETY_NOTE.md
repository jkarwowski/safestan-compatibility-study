# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the original response array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed-in-a-loop likelihood `y[i] ~ bernoulli_logit(theta - b[i])` by a single protected sampling statement `y_safestan_flat ~ bernoulli_logit(eta)` outside loops. The model computes `eta[(i - 1) * J + j] = theta[j] - b[i]`, so the summed Bernoulli-logit likelihood is the same as the original. `data_safe.json` replaces the original `y` with `y_safestan_flat = [y[1,1], ..., y[1,J], y[2,1], ..., y[I,J]]`. Parameter priors were already explicit and unchanged.
