# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected count vectors `y` are scored through a marginalized finite mixture likelihood implemented with manual `target += log_sum_exp(...)` accumulation and a user-defined `dm_lpmf`. Replacing this with SafeStan-compatible plain sampling statements would require a substantive likelihood/model rewrite, not a minor same-density mechanical translation.
