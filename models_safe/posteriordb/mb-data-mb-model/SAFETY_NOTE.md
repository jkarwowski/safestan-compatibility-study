# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model scores the capture-history matrix with manual `target +=` terms, including a marginalized latent inclusion component using `log_sum_exp` for all-zero histories. This likelihood is not a single built-in Stan sampling distribution for the top-level protected variable, and replacing it would require a substantive model rewrite or a change in the marginal likelihood. The protected data are also used in `transformed data` and `transformed parameters` before any SafeStan observation statement, but the primary blocker is the marginalized custom likelihood implemented through direct target manipulation.
