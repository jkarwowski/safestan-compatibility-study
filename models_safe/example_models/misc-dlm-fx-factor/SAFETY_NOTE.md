# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the prior statement `to_vector(G) ~ normal(0, 10)` with a SafeStan-compatible plain-identifier parameter prior. The original `matrix[1, 1] G` parameter was represented by a scalar parameter `G_raw` and a transformed-parameter matrix `G` with `G[1, 1] = G_raw`. This is a one-to-one deterministic reparameterization with unit Jacobian and preserves the posterior/log density. No data changes were required.
