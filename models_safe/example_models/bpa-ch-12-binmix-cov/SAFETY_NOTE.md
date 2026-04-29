# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed count array being scored by the likelihood. `R`, `T`, `K`, and `X` are context/configuration inputs.

Generated files: none.

Reason: the likelihood for `y` is a marginalized latent-population mixture implemented with manual `target += log_sum_exp(...)` scoring and explicit `_lpmf` calls inside nested loops. Replacing this with SafeStan sampling statements would require a substantive rewrite to a different likelihood representation, not a minor same-density translation. In addition, the parameters `alpha0`, `alpha1`, `beta0`, and `beta1` use implicit improper flat priors, while SafeStan requires each parameter to have exactly one built-in prior sampling statement before use; adding proper priors would change the posterior density.
