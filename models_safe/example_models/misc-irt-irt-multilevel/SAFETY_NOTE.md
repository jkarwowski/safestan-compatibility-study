# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response variable is `y`, but the original likelihood is written as indexed observations inside a loop (`y[n] ~ bernoulli_logit(...)`), which would require a minor vectorization/copy-style rewrite for SafeStan. More importantly, the scale parameters `sigma_alpha` and `sigma_beta` are top-level parameters with no explicit built-in prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these positive scale parameters would change the posterior/log density, and there is no finite-bound density-neutral uniform prior available for them. Therefore the model cannot be translated to SafeStan without a substantive density change.
