# SafeStan Safety Note

Compatibility: minor.

Protected data: `count_train`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: used a scalar protected `count_train` for the supplied `N_train = 1` data, scored it with the equivalent zero-truncated `poisson(exp(mu_indiv[1]))` likelihood because `poisson_log` has no truncation CDF signature, and guarded zero-length generated-quantity prediction loops.
