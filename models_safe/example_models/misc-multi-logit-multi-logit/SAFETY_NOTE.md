# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the elementwise protected-data likelihood `y[n] ~ categorical_logit(...)` inside a loop was replaced by the equivalent built-in vectorized likelihood `y ~ categorical_logit_glm(x, rep_vector(0, K), beta')`, so the protected top-level data variable is observed exactly once with a plain left-hand side. The prior was changed from `to_vector(beta) ~ cauchy(0, 2.5)` to the equivalent elementwise matrix statement `beta ~ cauchy(0, 2.5)`, making the top-level parameter the direct sampling target. The prior now appears before any use of `beta` in the likelihood. `data_safe.json` is unchanged from the supplied data.
