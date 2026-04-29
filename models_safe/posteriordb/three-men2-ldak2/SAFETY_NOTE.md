# SafeStan Safety Note

Compatibility: major.

Protected data: `w` would be the modelled word-token observation. `doc`, `M`, `N`, and `V` are context inputs, sizes, or indices.

Generated files: none.

Reason: the likelihood for `w` is a marginalized LDA token likelihood implemented with manual `target += log_sum_exp(gamma)` scoring inside a loop. SafeStan forbids arbitrary `target +=` scoring and requires each protected top-level data variable to be observed exactly once with a built-in distribution sampling statement. Replacing this marginalized likelihood with SafeStan-compatible sampling would require a substantive model rewrite, such as introducing latent topic indicators or changing to an aggregated multinomial likelihood with different normalizing constants, so this is not a minor same-density translation.
