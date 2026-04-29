# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood for `y` is implemented as a marginalized hidden Markov model using `target += hmm_marginal(log_omega, Gamma, rho)`, where `log_omega` is built from `normal_lpdf(y[n] | ...)` in `transformed parameters`. SafeStan forbids direct `target +=` scoring and also requires protected observations to be scored exactly once by a built-in sampling statement before other use. Replacing this marginalized HMM likelihood with SafeStan sampling statements would require a substantive model rewrite, such as changing the latent-state representation or likelihood algorithm, so no minor same-density translation is provided.
