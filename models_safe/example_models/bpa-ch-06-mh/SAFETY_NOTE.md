# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed capture count vector scored by the likelihood. `M` and `T` are context inputs.

Generated files: none.

Reason: the likelihood for `y` is implemented with manual `target +=` terms, including a marginalized latent inclusion mixture for zero counts via `log_sum_exp(...)` and branching on `y[i]`. SafeStan forbids arbitrary `target +=` scoring, and replacing this marginalized capture-recapture likelihood with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. The model also reads `y` in `transformed data` before any possible SafeStan observation statement.
