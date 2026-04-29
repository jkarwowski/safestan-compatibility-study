# SafeStan Safety Note

Compatibility: minor.

Protected data: `dN_active`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += poisson_lpmf(...)` likelihood over transformed-data increments with one vectorized built-in Poisson sampling statement for the top-level protected variable `dN_active`. Added `N_active` and `dN_active` to the data; `N_active` is the number of cells with `Y[i, j] != 0`, where `Y[i, j] = int_step(obs_t[i] - t[j] + 1e-9)`, and `dN_active` is the row-major list of the original transformed-data increments `Y[i, j] * fail[i] * int_step(t[j + 1] - obs_t[i] - 1e-9)` for those active cells. For the supplied data this gives `N_active = 3` and `dN_active = [0, 0, 0]`. The `dL0` prior was vectorized so that every parameter has one top-level built-in prior statement outside loops.
