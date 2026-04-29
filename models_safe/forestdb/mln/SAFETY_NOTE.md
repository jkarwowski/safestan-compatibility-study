# SafeStan Safety Note

Compatibility: minor.

Protected data: `spin`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the observation of `spin` so the protected top-level data variable appears exactly once on the left side of a sampling statement. Added `spin_safestan_copy`, a deterministic copy of `spin`, to supply the neighbor values that the original model read while constructing the Bernoulli-logit predictors before scoring each element. In `data_safe.json`, `spin_safestan_copy[i] = spin[i]` for all `i`. Parameter priors were already explicit built-in distributions and were kept unchanged.
