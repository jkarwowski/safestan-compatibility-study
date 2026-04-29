# SafeStan Safety Note

Compatibility: major.

Protected data: candidate protected observation is `Y`.

Generated files: none.

Reason: `Y` is scored through a manual `target += normal_lpdf(Y | mu, sigma)` likelihood inside the data-dependent condition `if (!prior_only)`. SafeStan forbids direct `target +=` scoring and requires each protected top-level data variable to be observed exactly once with a built-in sampling statement, without data-dependent gating unless all branches have identical sampling effects. Replacing this with an unconditional `Y ~ normal(mu, sigma)` would remove the `prior_only` branch and change the model/log density, while keeping the branch would violate SafeStan's control-flow rule. The target-based prior terms could largely be converted mechanically, but the conditional likelihood cannot be represented as a minor same-density SafeStan rewrite.
