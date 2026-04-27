# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for the count vectors is a finite Dirichlet-multinomial mixture with discrete component assignments marginalized via `log_sum_exp` and manual `target +=` scoring, using a custom `dm_lpmf` on protected observations. Representing this under SafeStan plain observation statements would require a substantive latent-mixture rewrite or a change to the likelihood/log density, so no same-density minor translation is produced.
