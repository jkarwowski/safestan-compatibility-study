# SafeStan Safety Note

Compatibility: major.

Protected data: `test_pos`.

Generated files: none.

Reason: the likelihood for `test_pos` is a marginalized binary latent-disease model implemented with direct `bernoulli_lpmf(...)` calls and `target += log_sum_exp(...)` manual scoring. Replacing this with SafeStan plain sampling statements would require a substantive rewrite of the latent-state marginalization or a different likelihood representation, so no same-density minor translation is available.
