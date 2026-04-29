# SafeStan Safety Note

Compatibility: major.

Protected data: `goal_difference`.

Generated files: none.

Reason: the likelihood scores `goal_difference[g]` inside a loop using the user-defined distribution `zero_inflated_skellam`, which itself calls a user-defined Skellam log PMF. SafeStan requires each protected top-level data variable to be observed exactly once with a plain left-hand-side identifier and a built-in Stan distribution. Replacing this zero-inflated Skellam likelihood with SafeStan sampling statements would require a substantive custom or latent-variable model rewrite and cannot be done as a minor same-density translation.
