# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite mixture implemented with manual `target += log_sum_exp(...)` scoring using `normal_lpdf` terms. SafeStan forbids arbitrary `target +=` scoring and requires each protected observation to be scored exactly once by a built-in sampling statement. Stan has no built-in sampling distribution for this rule-weighted normal mixture, so replacing the marginal likelihood would require a substantive model rewrite, such as introducing latent rule indicators or changing the likelihood representation.
