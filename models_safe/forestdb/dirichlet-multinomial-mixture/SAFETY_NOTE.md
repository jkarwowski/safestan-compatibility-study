# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite mixture. Each row is scored through a manually accumulated `target += log_sum_exp(...)` expression using a user-defined `dm_lpmf` component. SafeStan forbids arbitrary `target +=` scoring and requires each protected variable to be observed exactly once with a built-in distribution sampling statement. Replacing this marginalized mixture with SafeStan-compatible sampling statements would require a substantive model rewrite or a different likelihood representation, not a minor same-density translation.
