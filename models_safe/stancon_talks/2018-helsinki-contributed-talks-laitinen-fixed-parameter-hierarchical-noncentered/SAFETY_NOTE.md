# SafeStan Safety Note

Compatibility: major.

Protected data: `observations` and `mu` are directly scored as data; `kappa_log` is also indirectly scored through `kappa = exp(kappa_log)`, `kappa ~ normal(0, 5)`, and `target += sum(kappa_log)`.

Generated files: none.

Reason: the model uses multiple forbidden `target +=` statements, including a custom latent t-process prior for `epsilon` and Jacobian-style terms for transformed quantities. The parameter `epsilon` is given its density only through manual target increments rather than a single built-in prior sampling statement, and the transformed-data quantity `kappa` is sampled instead of a top-level data or parameter variable. Replacing these pieces with SafeStan sampling statements would require a substantive reparameterization or likelihood/prior change, not a minor same-density translation.
