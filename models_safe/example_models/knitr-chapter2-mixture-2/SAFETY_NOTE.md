# SafeStan Safety Note

Compatibility: major.

Protected data: `mu` is directly observed by `mu ~ normal(0, 10)`; `y` is observed by the finite-mixture likelihood accumulated with `target += log_sum_exp(...)`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized mixture implemented through manual `normal_lpdf` calculations and `target +=`. SafeStan requires protected observations to be scored exactly once via a top-level built-in sampling statement, and Stan has no built-in sampling statement for this finite normal mixture. Replacing it would require a substantive model rewrite rather than a minor same-density translation. The model also contains other non-SafeStan issues, but the manual marginalized mixture likelihood is sufficient to make this a major incompatibility.
