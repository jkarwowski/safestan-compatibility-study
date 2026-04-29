# SafeStan Safety Note

Compatibility: major.

Protected data: `likelihood` (with `H` and `N` as context inputs).

Generated files: none.

Reason: the likelihood contribution is implemented with manual `target += log_sum_exp(...)`, using `likelihood[n, h]` inside a marginalized finite-hypothesis calculation. SafeStan forbids arbitrary `target +=` scoring, and replacing this with built-in sampling statements on a plain top-level protected data variable would require a substantive model rewrite rather than a mechanical same-density translation.
