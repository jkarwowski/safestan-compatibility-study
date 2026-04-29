# SafeStan Safety Note

Compatibility: minor.

Protected data: `n_redcards`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the two indexed parameter prior statements `beta[1] ~ normal(0, 10)` and `beta[2] ~ normal(0, 1)` with a single vectorized built-in prior `beta ~ normal(beta_mu, beta_sigma)`. This preserves the same independent normal prior density while satisfying SafeStan's requirement that each top-level parameter be sampled exactly once using a plain identifier. No data changes were required.
