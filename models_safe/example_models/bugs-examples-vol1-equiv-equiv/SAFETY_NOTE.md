# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered all parameter prior sampling statements so each parameter is sampled before any model-block use. Replaced the looped indexed likelihood `Y[n] ~ normal(...)` with a single vectorized top-level observation statement `Y ~ normal(m, sigma1)`, where `m` is a local array of means computed before the observation. This preserves the same product normal likelihood while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level identifier. No data fields were added or changed.
