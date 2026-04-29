# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_obs`, a deterministic flattened copy of the `deaths[EpidemicStart[m]:N[m], m]` entries scored in the original model.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped slice likelihood with one top-level protected sampling statement, `deaths_obs ~ neg_binomial_2(E_deaths_obs, phi)`, using context index arrays to gather the matching expected-death means. Vectorized the elementwise prior loop for `y[m]` to `y ~ exponential(1 / tau)` so the parameter is scored once outside loops. The original `deaths` array is not declared in the SafeStan model; its modelled entries are supplied through the protected flattened copy.

Data relation: `N_deaths_obs`, `deaths_obs`, `deaths_obs_day`, and `deaths_obs_country` are deterministically constructed by scanning countries `m` and available days `i` with `EpidemicStart[m] <= i <= N[m]` and `1 <= i <= N2`, then copying `deaths[i, m]`. For the supplied synthetic data this set is empty, so the added arrays are empty.
