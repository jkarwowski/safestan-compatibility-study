# SafeStan Safety Note

Compatibility: minor.

Protected data: `N1_safestan_obs`, `obs_times`, `N3_safestan_obs`, and `N4_safestan_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced manual `target +=` likelihood contributions with built-in sampling statements. The exact observation loop is equivalent to `obs_times ~ exponential(gamma)`. The censored count terms `N1 * log_p1`, `N3 * log_p3`, and `N4 * log_p4` are represented by binomial observations on deterministic protected copies with all trials successful: `N1_safestan_obs ~ binomial(N1, p1)`, `N3_safestan_obs ~ binomial(N3, p3)`, and `N4_safestan_obs ~ binomial(N4, p4)`. When each protected copy equals its corresponding count, the binomial log PMF reduces exactly to the original count times the log probability. The parameter prior for `gamma` was moved before computations depending on `gamma` to satisfy SafeStan parameter-use ordering.

Data augmentation: added `N1_safestan_obs = N1`, `N3_safestan_obs = N3`, and `N4_safestan_obs = N4` as deterministic copies of supplied data fields.
