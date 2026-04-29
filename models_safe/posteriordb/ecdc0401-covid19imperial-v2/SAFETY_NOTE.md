# SafeStan Safety Note

Compatibility: minor.

Protected data: `deaths_safestan`, a deterministic flattening of the originally scored `deaths[EpidemicStart[m]:N[m], m]` slices.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped, sliced death likelihood with one top-level protected array `deaths_safestan` observed once in a single `neg_binomial_2` sampling statement. Added `N_deaths_safestan`, the deterministic length of that flattened array. Vectorized the prior on `y` from `y[m] ~ exponential(1 / tau)` inside a loop to `y ~ exponential(1 / tau)`. The original unused full `deaths` matrix is omitted from the safe data interface; `deaths_safestan` is computed from the supplied `deaths`, `EpidemicStart`, and `N` values. For the supplied synthetic data this deterministic flattening is empty because no country has `EpidemicStart[m] <= N[m]`.
