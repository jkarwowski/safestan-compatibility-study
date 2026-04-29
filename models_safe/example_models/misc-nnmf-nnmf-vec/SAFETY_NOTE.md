# SafeStan Safety Note

Compatibility: minor.

Protected data: `X`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `X_safestan_copy`, a deterministic top-level data copy with `X_safestan_copy[t, i] = X[t, i]`, so transformed-data computations of `g_bar` and `g_sigma` do not read protected `X` before it is observed. Added `sigma_matrix`, a deterministic transformed-data expansion of `sigma`, to express the likelihood as one top-level sampling statement. Replaced the row-wise `G[t] ~ lognormal(...)` prior with the equivalent vectorized `G ~ lognormal(...)`, and replaced the row-wise `X[t] ~ normal(...)` likelihood with the equivalent vectorized `X ~ normal(...)`. Added `F ~ dirichlet(rep_vector(1.0, I))` to make explicit the flat simplex prior implicit in the original constrained simplex parameter and satisfy SafeStan's unique-prior requirement.
