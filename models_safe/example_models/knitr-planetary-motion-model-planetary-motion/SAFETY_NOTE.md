# SafeStan Safety Note

Compatibility: minor.

Protected data: `q_obs_x`, `q_obs_y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored the protected observation `q_obs` through two projected left-hand sides, `q_obs[ : , 1]` and `q_obs[ : , 2]`. SafeStan requires protected observations to be top-level identifiers, each scored exactly once. The safe version replaces `q_obs` by two deterministic top-level protected column arrays: `q_obs_x[i] = q_obs[i, 1]` and `q_obs_y[i] = q_obs[i, 2]`. The two Normal likelihood factors are otherwise unchanged, so the posterior/log density is preserved under this deterministic reshape. The existing `k ~ normal(0, 1)` prior is unchanged.
