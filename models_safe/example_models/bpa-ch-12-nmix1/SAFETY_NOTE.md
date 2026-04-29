# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized zero-inflated N-mixture model implemented with manual `target +=` statements, `log_sum_exp`, and user-defined `_lpmf` functions. The protected data are also inspected in transformed data/control flow before any SafeStan-compatible observation statement. Replacing this with a single built-in sampling statement for top-level `y` would require a substantive statistical/model rewrite rather than a minor same-density translation.
