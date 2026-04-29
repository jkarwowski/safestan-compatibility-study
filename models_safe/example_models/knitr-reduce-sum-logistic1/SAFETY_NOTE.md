# SafeStan Safety Note

Compatibility: minor.

Protected data: `n_redcards`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the `reduce_sum`/`target +=` likelihood implemented through a user-defined partial-sum log-probability function with the equivalent vectorized built-in sampling statement `n_redcards ~ binomial_logit(...)`. Combined the two component priors for `beta[1]` and `beta[2]` into one top-level vectorized prior `beta ~ normal(...)` so the parameter `beta` is observed by exactly one built-in prior statement. The data file is unchanged; `grainsize` is retained as an unused context input.
