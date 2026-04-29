# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_initial` and `y_tail`, which are deterministic reshapes of the original sequence `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += categorical_lpmf(...)` Markov-chain likelihood with built-in `categorical` sampling statements. Because SafeStan requires protected observations to be top-level identifiers observed exactly once, the original `y` array was reshaped into `y_initial = y[1]`, protected `y_tail[t] = y[t + 1]`, and context lag copy `y_lag[t] = y[t]` for `t = 1, ..., T - 1`. The original transition-matrix prior loop was replaced by the equivalent vectorized statement `A ~ dirichlet(rep_vector(1.0, S))`, so `A` is sampled as a top-level parameter exactly once. For data satisfying these deterministic relations, the posterior/log density is unchanged.
