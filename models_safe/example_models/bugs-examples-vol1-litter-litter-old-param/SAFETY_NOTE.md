# SafeStan Safety Note

Compatibility: minor.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped the two-dimensional count arrays `r` and `n` into one-dimensional arrays in row-major order with index `k = (g - 1) * N + i`. Replaced the nested indexed sampling statements with vectorized top-level sampling statements. Reparameterized the latent beta probabilities as `p_safestan_flat` and reconstructed the original matrix-shaped `p` deterministically in `transformed parameters`. These are mechanical same-density changes preserving the original product of gamma, beta, and binomial terms.
