# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y_safestan_flat`, a deterministic row-major reshape of the original observed `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed likelihood statements for `Y[k, n]` inside nested loops with one top-level sampling statement for `Y_safestan_flat`. The data relation is `Y_safestan_flat[(k - 1) * N + n] = Y[k, n]` for Stan indices `k = 1..K`, `n = 1..N`; all other data are copied unchanged. Reordered and vectorized parameter priors so each top-level parameter is sampled exactly once before use: `sigmasq`, `mu`, `sigma2`, and `theta`. These changes preserve the same joint log density.
