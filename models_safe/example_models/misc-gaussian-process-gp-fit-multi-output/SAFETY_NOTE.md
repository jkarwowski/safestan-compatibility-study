# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_vec`, a deterministic column-major vectorization of the original observed matrix `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_vec` with `y_safestan_vec[(d - 1) * N + n] = y[n, d]` for 1-based indices, matching Stan's `to_vector(y)` used in the original likelihood. The likelihood is now `y_safestan_vec ~ normal(to_vector(f), sigma)` so the protected observation is a plain top-level data identifier. The original `y` field is retained as unused data for schema continuity. The latent `eta` matrix parameter was rewritten as a vector parameter with the same column-major layout and reconstructed by `to_matrix(eta, N, D)`, turning `to_vector(eta) ~ normal(0, 1)` into the SafeStan prior `eta ~ normal(0, 1)`. Parameter prior statements were moved before the deterministic GP computations that use those parameters. These are order/reshape-only changes and preserve the original log density for consistent data.
