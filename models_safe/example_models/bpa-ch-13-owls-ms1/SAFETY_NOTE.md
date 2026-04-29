# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation model for `y` is a marginalized multistate occupancy likelihood implemented with manual `target += log_sum_exp(...)` scoring over latent site states, with indexed reads of `y` inside a missingness gate (`if (y[s, t])`). SafeStan forbids arbitrary `target +=` likelihood contributions and requires each protected top-level observation to be scored exactly once by a built-in sampling statement. Replacing this marginalized likelihood would require a substantive model rewrite, such as introducing latent discrete states or encoding full site-level observation histories with custom probabilities, and is not a minor same-density translation.
