# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized multistate occupancy likelihood implemented with manual `target += log_sum_exp(...)` scoring and direct `categorical_lpmf(...)` calls. The protected data are also inspected in `if (y[s, t])` before any SafeStan-style observation statement. Replacing this with SafeStan-compatible built-in sampling statements would require a substantive rewrite of the marginalized latent-state algorithm and would not be a minor same-density translation.
