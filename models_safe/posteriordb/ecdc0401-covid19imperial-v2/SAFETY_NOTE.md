# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored country-specific slices of `deaths` inside a loop. SafeStan requires a protected observation to be a top-level data variable sampled exactly once with a plain identifier, so the scored death entries are flattened into the deterministic top-level data variable `deaths_obs`. The model builds the matching `E_deaths_obs` vector and uses one vectorized `deaths_obs ~ neg_binomial_2(E_deaths_obs, phi)` statement. The prior `y[m] ~ exponential(1 / tau)` inside a loop was equivalently vectorized to `y ~ exponential(1 / tau)` so the top-level parameter `y` has one prior statement outside control flow.

Data additions: `N_obs = sum_m (N[m] - EpidemicStart[m] + 1)` and `deaths_obs` is the concatenation, in increasing country `m` and day `i`, of the original `deaths[i, m]` for `i = EpidemicStart[m], ..., N[m]`.
