# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed count outcome is `y`, scored by `y ~ poisson_log(...)`. However, the model also defines the spatial prior for `phi` using manual `target += -0.5 * dot_self(phi[node1] - phi[node2])` scoring, and a soft sum-to-zero constraint via `sum(phi) ~ normal(...)`, whose left-hand side is an expression rather than a top-level parameter. SafeStan forbids `target +=` and requires each parameter to have exactly one built-in prior sampling statement on the top-level parameter before use. Replacing this intrinsic CAR/BYM2 prior construction with SafeStan-compatible built-in sampling statements would be a substantive model/density rewrite rather than a minor mechanical translation.
