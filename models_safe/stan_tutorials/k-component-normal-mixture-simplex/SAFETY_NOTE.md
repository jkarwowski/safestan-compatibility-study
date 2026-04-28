# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite normal mixture implemented with manual log-density construction (`normal_lupdf(...)`) and `target += log_mix(theta, ps)`. SafeStan forbids `target +=` and requires each protected data variable to be observed exactly once by a built-in sampling statement with a plain top-level variable on the left-hand side. Stan has no built-in K-component marginalized normal-mixture sampling statement equivalent to this code, and replacing the algorithm with latent allocations or another construction would be a substantive model rewrite rather than a minor same-density translation.
