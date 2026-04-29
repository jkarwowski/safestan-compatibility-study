# SafeStan Safety Note

Compatibility: minor.

Protected data: `r_safestan_flat`, a deterministic flattened expansion of the compressed LSAT response patterns.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scores `r[k]`, where `r` is transformed data constructed from `response` and `culm`. SafeStan requires observed variables on the left side of `~` to be top-level protected data and not indexed. I added `r_safestan_flat` as top-level data and replaced the loop of indexed Bernoulli-logit sampling statements with one vectorized sampling statement. The deterministic relation is `r_safestan_flat[(k - 1) * N + j] = r[k, j]`, where `r` is the expanded response array defined by the original transformed-data construction. The existing built-in priors for `alpha`, `theta`, and `beta` were retained.
