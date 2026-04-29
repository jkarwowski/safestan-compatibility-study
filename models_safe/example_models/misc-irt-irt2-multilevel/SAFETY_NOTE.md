# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the hyperparameter priors so that `sigma_alpha`, `sigma_beta`, and `sigma_gamma` are sampled before they are used as prior scales for `alpha`, `beta`, and `log_gamma`. Replaced the indexed likelihood statements `y[n] ~ bernoulli_logit(...)` inside the loop with a deterministic computation of `eta` followed by the equivalent vectorized protected observation `y ~ bernoulli_logit(eta)`. The data file is unchanged; `J`, `K`, `N`, `jj`, and `kk` are context inputs, not protected observations.
