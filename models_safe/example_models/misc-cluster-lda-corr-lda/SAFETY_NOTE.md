# SafeStan Safety Note

Compatibility: major.

Protected data choice: `w` (the observed word-token array). The other data variables (`K`, `V`, `M`, `N`, `doc`, and `beta`) are context inputs used for sizes, indexing, and priors.

Generated files: none.

Reason: the likelihood for `w` is implemented manually with `target += log_sum_exp(gamma)` inside a token loop, marginalizing over latent topic assignments. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by a built-in distribution with a plain top-level left-hand side. Translating this marginalized LDA token likelihood would require a substantive rewrite, such as introducing a different summarized observation interface or replacing the manual marginalized likelihood with a nontrivial built-in-distribution construction. That is beyond a minor same-density SafeStan translation.
