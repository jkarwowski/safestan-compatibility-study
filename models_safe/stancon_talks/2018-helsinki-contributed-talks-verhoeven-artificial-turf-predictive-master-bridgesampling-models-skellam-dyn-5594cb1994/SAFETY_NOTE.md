# SafeStan Safety Note

Compatibility: major.

Protected data: `goal_difference`.

Generated files: none.

Reason: the likelihood for `goal_difference` is implemented with `target += skellam_lpmf(goal_difference[g] | ...)` inside a loop, using a user-defined `skellam_lpmf`. SafeStan forbids arbitrary `target +=` scoring and rejects user-defined distributions for sampling statements. Replacing this with SafeStan-compatible built-in observation statements would require a substantive likelihood/model rewrite rather than a minor same-density translation.
