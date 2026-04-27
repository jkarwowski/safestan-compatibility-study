# SafeStan Safety Note

Compatibility: minor.

Protected data: original sequence `y`, represented in the SafeStan file by top-level observations `y_initial`, `y_after_1`, `y_after_2`, and `y_after_3`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += categorical_lpmf(...)` likelihood with plain categorical sampling statements. For the supplied data `S = 3`, the transition observations were deterministically reshaped so that `y_initial = y[1]`; for each state `s`, `N_from_s` is the number of transitions with previous state `s`, and `y_after_s` is the list of following states `y[t]` for `t = 2, ..., T` such that `y[t - 1] = s`, in increasing time order. This only reorders the same categorical transition factors, so the posterior/log density is unchanged. The original Dirichlet priors are preserved and appear before the likelihood.
