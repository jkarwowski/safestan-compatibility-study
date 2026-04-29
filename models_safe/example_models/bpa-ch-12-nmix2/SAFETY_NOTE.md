# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed count array scored by the likelihood through slices `y[i, 1:2, k]`.

Generated files: none.

Reason: the likelihood is a custom marginalized bivariate Poisson distribution implemented as a user-defined `_lpmf` with `log_sum_exp` over latent states and used via `y[i, 1:2, k] ~ bivariate_poisson_log(...)` inside loops. SafeStan requires protected observations to be scored exactly once as a plain top-level identifier by a built-in Stan distribution, and also rejects user-defined distributions in sampling statements, `reject()`, and `_lp`/`_lpmf` style likelihood functions. Replacing this with SafeStan-compatible built-in sampling statements would require a substantive likelihood/model rewrite rather than a mechanical same-density translation.
