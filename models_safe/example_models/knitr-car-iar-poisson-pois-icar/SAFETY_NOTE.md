# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is the built-in statement `y ~ poisson_log(...)`, but the spatial latent prior is implemented with a user-defined distribution `icar_normal_lpdf` and an additional soft constraint `sum(phi) ~ normal(...)` whose left side is an expression. SafeStan requires each parameter to have exactly one built-in prior sampling statement before use, and rejects user-defined distributions in `~` as well as parameter-prior sampling statements on expressions. Replacing the ICAR prior plus soft sum-to-zero constraint with a single SafeStan-compatible built-in prior would be a substantive model/density rewrite, not a minor mechanical translation.
