# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_observed`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `N_deaths_observed` and `deaths_observed`, where `deaths_observed` is the deterministic flattening, in the original likelihood order, of `deaths[i, m]` for countries `m = 1..M` and days `i` with `EpidemicStart[m] <= i <= N[m]`; `N_deaths_observed` is its length. For the supplied synthetic data this gives `deaths_observed = [3, 5]`. The looped/sliced deaths likelihood was replaced by one vectorized sampling statement on this protected top-level copy. The elementwise prior loop for parameter `y` was vectorized to the equivalent top-level prior `y ~ exponential(1 / tau)`.
