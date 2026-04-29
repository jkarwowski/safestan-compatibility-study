# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped indexed likelihood `y[n] ~ bernoulli_logit(...)` with a deterministic vector of logits `eta` followed by a single top-level observation statement `y ~ bernoulli_logit(eta)`. This preserves the same Bernoulli-logit likelihood while satisfying SafeStan's requirement that protected data be observed exactly once as a plain top-level identifier and not inside a loop. Also changed `to_vector(w1) ~ normal(0, 1)` to `w1 ~ normal(0, 1)`, which is the same elementwise normal prior density but targets the top-level parameter directly.

No data fields were added or changed; `data_safe.json` is the supplied data.
