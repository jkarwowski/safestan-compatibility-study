# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed response scored by `y ~ normal(y_hat, sigma)` in the original model.

Generated files: none.

Reason: the original density cannot be represented in the SafeStan subset by a minor same-density rewrite. The parameter `sigma` is used in the likelihood but has no explicit proper built-in prior; adding one would change the model. In addition, `B_raw_temp` is sampled inside a loop over `J`, so the same top-level parameter is scored repeatedly and inside control flow, which SafeStan forbids. Moving or replacing that statement would change the original density for general `J` or require a substantive reparameterization.
