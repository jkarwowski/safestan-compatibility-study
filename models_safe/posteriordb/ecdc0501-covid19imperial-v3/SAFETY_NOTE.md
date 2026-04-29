# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_safestan` (a deterministic copy/reshape of the originally scored `deaths` entries).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added context `N_deaths_observed` and protected data `deaths_safestan`. The new protected array is formed in country-major order from `deaths[i, m]` for all `m` and `i = EpidemicStart[m], ..., min(N[m], N2)`; when the model's stated data condition `N[m] <= N2` holds, this is exactly the original likelihood slice `deaths[EpidemicStart[m] : N[m], m]`. For the supplied synthetic JSON this deterministic relation gives `N_deaths_observed = 0` and `deaths_safestan = []`. The looped sliced likelihood was replaced by a single vectorized built-in `neg_binomial_2` sampling statement, and the elementwise prior on `y` was vectorized, preserving the same log density while satisfying SafeStan's single-use and no-sampling-in-loops restrictions.
