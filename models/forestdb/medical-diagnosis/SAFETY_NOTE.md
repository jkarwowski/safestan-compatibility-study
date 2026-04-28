# SafeStan Safety Note

Compatibility: major.

Protected data: `test_pos`.

Generated files: none.

Reason: the likelihood for `test_pos` is a marginalized binary disease model implemented with manual `bernoulli_lpmf(...)` terms and `target += log_sum_exp(...)`. Replacing this custom marginalized scoring with SafeStan plain sampling statements would require a substantive model rewrite or a change to the represented density, so no minor same-density SafeStan translation is produced.
