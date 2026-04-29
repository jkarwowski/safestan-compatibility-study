# SafeStan Safety Note

Compatibility: major.

Protected data choice: no valid SafeStan-compatible top-level protected variable is available as written. The model observes `sqrt_dif` with `sqrt_dif ~ student_t(...)`, but `sqrt_dif` is a transformed-data value computed from `score_1` and `score_2`, not a top-level data variable.

Generated files: none.

Reason: the likelihood is applied to a transformed-data statistic rather than a plain top-level data identifier, and converting the original `score_1`/`score_2` interface into a normalized SafeStan likelihood would require a substantive likelihood/interface rewrite. In addition, parameters `b`, `sigma_a`, and `sigma_y` have no explicit priors; adding proper priors would change the posterior, while their current implicit flat/improper densities cannot satisfy SafeStan's unique built-in-prior requirement as a minor density-preserving rewrite.
