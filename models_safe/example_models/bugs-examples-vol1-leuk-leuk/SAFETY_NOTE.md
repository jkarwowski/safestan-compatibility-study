# SafeStan Safety Note

Compatibility: minor.

Protected data: `dN_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += poisson_lpmf(...)` counting-process likelihood with one vectorized built-in Poisson sampling statement on a top-level protected data vector. Added deterministic data fields `N_risk`, `risk_i`, `risk_j`, and `dN_safestan`: these are the at-risk `(i, j)` cells from the original transformed-data construction, in row-major loop order, and the corresponding `dN[i, j]` values. The original data fields are retained. Vectorized the `dL0` gamma prior so the top-level parameter is sampled exactly once outside loops. The posterior density is otherwise unchanged.
