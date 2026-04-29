# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ lognormal(log(y_pred), sigma)`, so `y` is the protected interface variable and `N`/`x` are context inputs. However, the parameters `a`, `b`, and `sigma` are used in the likelihood without any explicit built-in prior sampling statements. SafeStan requires each parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these positive/unbounded parameters would change the posterior density, and there is no minor same-density rewrite that supplies the required priors.
