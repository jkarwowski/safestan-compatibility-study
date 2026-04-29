# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += normal_lpdf(delta | 0, 3)` prior with the algebraically equivalent built-in prior `delta_free ~ multi_normal_prec(...)` on the free sum-to-zero item parameters. Reordered parameter priors so that `lambda_adj` and `sigma` are observed before they are used in the conditional prior for `theta`, and `delta_free` is observed before `delta` is used in the likelihood. The likelihood for protected data remains the single top-level statement `y ~ bernoulli_logit(theta[jj] - delta[ii])`. The supplied data were not changed. The generated-quantities calculation for `lambda` was guarded for `K == 1` to avoid an out-of-range empty-tail slice while preserving the original formula for `K > 1` and not changing the posterior/log density.
