# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_observed`, a deterministic flattening of the observed entries of original data variable `deaths`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped, sliced likelihood `deaths[EpidemicStart[m] : N[m], m] ~ neg_binomial_2(...)` with a single vectorized likelihood on the top-level protected variable `deaths_observed`. The added data fields `N_deaths_observed`, `deaths_observed`, `deaths_observed_day`, and `deaths_observed_country` are deterministic from `deaths`, `EpidemicStart`, and `N`: in country-major order, for each country `m`, include each day `i` from `EpidemicStart[m]` through `N[m]`; `deaths_observed[k] = deaths[i, m]` with matching day and country index arrays. For this synthetic input that interval is empty, so the added arrays are empty. Also vectorized the prior on parameter `y` from per-country looped statements to the equivalent single statement `y ~ exponential(1 / tau);` so that parameter prior sampling is not inside a loop.
