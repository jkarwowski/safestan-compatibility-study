# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model scores the observed uncensored values `y` and also uses `N_censored` as the observed multiplicity of censored observations through the censored-tail likelihood contribution. `U` and `N_observed` are context/configuration inputs.

Generated files: none.

Reason: the censored-observation contribution is implemented with forbidden manual scoring, `target += N_censored * normal_lccdf(U | mu, 1)`. More importantly, the parameter `mu` has only an implicit improper flat prior in the original model. SafeStan requires every parameter to have exactly one built-in prior before use; adding a proper prior for `mu` would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor rewrite.
