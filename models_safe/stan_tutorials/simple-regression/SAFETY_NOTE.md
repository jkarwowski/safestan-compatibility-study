# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ normal(a + b * x, sigma)`, so `y` is the protected interface and `x`/`N` are context inputs. However, the parameters `a`, `b`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding priors for these unconstrained or half-line-constrained parameters would change the original posterior/log density, so this cannot be translated by a minor same-density rewrite.
