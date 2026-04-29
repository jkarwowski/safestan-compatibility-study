# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y1_safestan_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level data variable `Y1_safestan_obs` and changed the likelihood from `Y[1] ~ binomial_logit(...)` to `Y1_safestan_obs ~ binomial_logit(...)`, because SafeStan requires protected observations to be top-level plain identifiers. In `data_safe.json`, `Y1_safestan_obs` is deterministically set to an array of length `I` whose entries are all `1`, exactly matching the original transformed-data construction `Y[1, i] = 1` for `i = 1:I`. The original count inputs `n10`, `n01`, `n11`, and `I` remain context inputs. The prior on `beta` was already explicit and unchanged.
