# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y1` and `Y2` (the two rows of the original transformed-data observation `Y`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: lifted the deterministic transformed-data observations to top-level protected data variables: `Y1[i] = 1` and `Y2[i] = 0` for `i = 1, ..., I`, exactly matching the original assignments to `Y[1, i]` and `Y[2, i]`. Replaced the looped indexed likelihood `Y[j] ~ poisson_log(...)` with two vectorized built-in sampling statements whose left sides are plain protected identifiers. The predictor `est` and the priors on `beta` and `beta0` are unchanged. The generated data omits the supplied extra `J` field because `J` was a transformed-data constant, not a declared top-level data input.
