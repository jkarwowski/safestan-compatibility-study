# SafeStan Safety Note

Compatibility: major.

Protected data: `y_obs`.

Generated files: none.

Reason: the observed interface variable is `y_obs`, which is scored once with a built-in `neg_binomial_2_log` likelihood. However, the model also defines a marginalized normal-mixture prior for `delta_days_tilde` using `target += log_mix(...)` inside a loop. SafeStan forbids manual `target +=` scoring, and there is no equivalent single built-in Stan sampling statement for this mixture prior. Replacing it would require a substantive latent-mixture/model rewrite rather than a minor same-density translation.
