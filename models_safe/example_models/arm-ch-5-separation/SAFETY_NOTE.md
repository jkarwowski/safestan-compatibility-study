# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ bernoulli_logit_glm(x, alpha, beta)`, so `y` is the protected interface variable and `N`/`x` are context inputs. However, the parameters `alpha` and `beta` have no sampling statements before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. These parameters are unconstrained, so Stan's implicit priors are improper flat densities on unbounded spaces; adding explicit proper priors would change the posterior/log density. Therefore this cannot be made SafeStan-compatible by a minor same-density rewrite.
