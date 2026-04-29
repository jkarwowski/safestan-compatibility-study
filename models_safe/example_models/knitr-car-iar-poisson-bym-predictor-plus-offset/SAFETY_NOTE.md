# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y`, because it is the top-level observed count outcome scored by `y ~ poisson_log(...)`.

Generated files: none.

Reason: the likelihood observation for `y` is identifiable, but the model is not SafeStan-compatible because the spatial prior for `phi` is implemented with manual `target += -0.5 * dot_self(phi[node1] - phi[node2])`, and the additional soft constraint is written as `sum(phi) ~ normal(...)` with a non-top-level expression on the left-hand side. SafeStan forbids `target +=` and requires each parameter to have exactly one built-in prior sampling statement on a top-level parameter before use. Replacing the intrinsic CAR/BYM prior and soft constraint with a single built-in distribution would be a substantive prior/density rewrite rather than a minor mechanical translation.
