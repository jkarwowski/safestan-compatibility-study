# SafeStan Safety Note

Compatibility: major.

Protected data: `test_pos`.

Generated files: none.

Reason: the likelihood for `test_pos` is a marginalized binary-disease mixture implemented with manual `bernoulli_lpmf` accumulation and `target += log_sum_exp(...)`. SafeStan requires each protected variable to be scored exactly once as a plain left-hand side of a built-in sampling statement, and forbids manual target scoring and `_lpmf` likelihood construction. Replacing this with SafeStan-compatible sampling would require a substantive rewrite of the marginalized latent-state algorithm, not a minor same-density translation.
