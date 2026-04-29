# SafeStan Safety Note

Compatibility: major.

Protected data: the model conditions on `log_lik` through a marginalized latent-state likelihood computed with `target += log_sum_exp(...)`.

Generated files: none.

Reason: SafeStan forbids manual `target +=` scoring. Replacing the marginalized finite-state likelihood with protected-data sampling statements would require a substantive model rewrite or a different likelihood representation, not a minor same-density translation.
