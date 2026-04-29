# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history matrix; the likelihood depends on its row totals).

Generated files: none.

Reason: the likelihood is implemented with manual `target +=` statements and a marginalized zero-inflated/binomial mixture using `log_sum_exp`. SafeStan forbids arbitrary target manipulation, and expressing this same marginalized likelihood would require a substantive rewrite, such as introducing a derived count/category interface or changing the latent-state representation. That is not a minor same-density SafeStan translation of the original protected data interface.
