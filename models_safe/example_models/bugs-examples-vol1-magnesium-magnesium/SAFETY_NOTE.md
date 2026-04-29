# SafeStan Safety Note

Compatibility: minor.

Protected data: `rc_safestan_by_prior`, `rt_safestan_by_prior`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scores `rc` and `rt` once for each of the six prior specifications inside loops. SafeStan requires each protected data variable to be observed exactly once and not inside a loop, so `data_safe.json` adds deterministic top-level copies `rc_safestan_by_prior` and `rt_safestan_by_prior` with `rc_safestan_by_prior[prior, i] = rc[i]` and `rt_safestan_by_prior[prior, i] = rt[i]` for `prior = 1, ..., 6`. The likelihood and the looped priors for `pc` and `theta` were vectorized into single sampling statements. `nt_by_prior` and `nc_by_prior` are deterministic transformed-data copies of the unprotected trial-count inputs. These changes preserve the original log density for the supplied augmented data.
