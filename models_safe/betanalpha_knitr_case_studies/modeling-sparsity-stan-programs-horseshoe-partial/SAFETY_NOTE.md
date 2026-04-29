# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter priors so that `lambda` and `tau` are sampled before they are used in the prior scale for `theta_tilde`. Replaced the loop of indexed prior statements `theta_tilde[k] ~ normal(...)` with a single top-level vectorized prior `theta_tilde ~ normal(0, theta_tilde_scale)`, where `theta_tilde_scale[k]` is the same deterministic scale as in the original model. This preserves the same joint density while satisfying SafeStan's requirement that each parameter have exactly one non-loop built-in prior sampling statement with a plain top-level left-hand side.

No data changes were required.
