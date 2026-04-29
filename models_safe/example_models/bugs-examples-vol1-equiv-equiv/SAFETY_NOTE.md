# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the row-wise likelihood `Y[n] ~ normal(...)` was rewritten as one vectorized built-in sampling statement `Y ~ normal(m, sigma1)` with a full `array[N, P] real m` computed in the model block. Parameter prior statements were moved before any model-block use of those parameters. The supplied data were not changed.
