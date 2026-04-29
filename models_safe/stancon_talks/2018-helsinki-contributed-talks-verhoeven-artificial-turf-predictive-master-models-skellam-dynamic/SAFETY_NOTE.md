# SafeStan Safety Note

Compatibility: major.

Protected data: `goal_difference`.

Generated files: none.

Reason: the likelihood scores `goal_difference[g]` inside a loop using the user-defined distribution `zero_inflated_skellam`, which is implemented by custom `_lpmf` functions. SafeStan requires protected observations to be scored exactly once as a plain top-level identifier using a built-in Stan distribution. There is no built-in zero-inflated Skellam distribution, and replacing this marginalized likelihood with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation.
