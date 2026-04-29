# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ poisson_log(...)`, so `y` is the protected interface variable. However, the model also uses a custom CAR/ICAR prior for `phi` via `target += -0.5 * dot_self(phi[node1] - phi[node2])` and a non-top-level sampling statement `sum(phi) ~ normal(...)`. SafeStan forbids arbitrary `target +=` scoring and requires each parameter prior to be a built-in sampling statement on the top-level parameter. Replacing this custom graph prior with a SafeStan-compatible built-in multivariate prior would be a substantive prior rewrite and would alter/add normalization constants, so this is not a minor same-density translation.
