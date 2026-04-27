# SafeStan Safety Note

Compatibility: major.

Protected data: `calls`.

Generated files: none.

Reason: the likelihood for `calls` is implemented with direct `bernoulli_lpmf` calls and `target += log_sum_exp(...)` after marginalizing the binary burglary, earthquake, and alarm latent states. Replacing this marginalized hidden-state/manual-scoring calculation with SafeStan plain sampling statements would require a substantive model rewrite or a change to the represented density.
