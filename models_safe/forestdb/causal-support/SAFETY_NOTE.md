# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood is driven by `log_lik` as a precomputed log-likelihood table; `prior_concentration`, `N`, and `S` are context inputs.

Generated files: none.

Reason: the model uses `target += log_sum_exp(...)` inside a marginalized latent-state likelihood. SafeStan forbids arbitrary `target +=` scoring, and replacing this table-based marginalized likelihood with built-in sampling statements over a top-level protected observation would require a substantive model rewrite and additional modelling assumptions. Therefore no same-density minor SafeStan translation is available.
