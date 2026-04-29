# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed count array scored by the likelihood.

Generated files: none.

Reason: the model implements a zero-inflated marginalized N-mixture likelihood with manual `target +=` statements, `log_sum_exp` mixture terms, and user-defined log-probability functions. The functions also contain `reject()` checks. Translating this to SafeStan sampling statements would require a substantive likelihood/model rewrite rather than a minor same-density mechanical change.
