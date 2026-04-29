# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ bernoulli_logit(eta)`, so `y` is the protected data variable. The model is not SafeStan-compatible because parameter `gamma` is used in the model block to construct `theta` but has no sampling statement/prior. Adding a proper built-in prior for unconstrained `gamma` would change the posterior/log density, and there is no density-neutral finite-bound uniform prior available. Therefore this cannot be translated with only a minor same-density rewrite.
