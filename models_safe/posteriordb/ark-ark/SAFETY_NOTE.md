# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_response`, a deterministic tail copy of the modeled observations from original `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `N_safestan_obs = max(T - K, 0)` and `y_safestan_response = y[(K + 1):T]` when `T > K` (empty otherwise). For the supplied synthetic data this response tail is empty because `K = 4` and `T = 2`. The indexed likelihood inside the loop was rewritten as a single vectorized sampling statement on the top-level protected variable. The AR lag calculations remain deterministic helper computations using the original `y` as context, preserving the original log density for the supplied data relation.
