# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_calib`, `obs_t_fall`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood for `obs_t_fall` was written as indexed sampling statements inside nested loops. SafeStan requires a protected observation to be scored exactly once as a plain top-level identifier outside loops, so `obs_t_fall` is represented in `model_safe.stan` as a length `N_drops * N_heights` vector and scored once with a vectorized `normal` statement. `data_safe.json` deterministically flattens the supplied nested `obs_t_fall` array in drop-major order: Stan element `(n - 1) * N_heights + h` is the original `obs_t_fall[n][h]`. The mean vector is filled with the same indexing, preserving the original product likelihood. Priors and generated quantities are otherwise unchanged.
