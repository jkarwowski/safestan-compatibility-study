# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the augmented capture-history). `M` and `n_occasions` are context/size inputs.

Generated files: none.

Reason: the likelihood is implemented inside the user-defined `_lp` function `js_super_lp`, uses `target += log_sum_exp(...)` for marginalized latent-state terms, and includes indexed/looped observation statements such as `y[i, t] ~ bernoulli(...)` plus constant-valued scoring statements. Replacing this Jolly-Seber superpopulation likelihood with SafeStan-compatible built-in sampling statements on a single top-level protected variable would require a substantive likelihood/model rewrite rather than a minor mechanical translation.
