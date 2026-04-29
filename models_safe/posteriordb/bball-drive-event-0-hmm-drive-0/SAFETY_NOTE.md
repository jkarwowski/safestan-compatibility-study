# SafeStan Safety Note

Compatibility: major.

Protected data choice: `u` and `v` are the observed emission sequences scored by the HMM likelihood. `K`, `N`, and `alpha` are context inputs.

Generated files: none.

Reason: the model uses a marginalized Hidden Markov Model likelihood implemented by a forward algorithm with manual `target += log_sum_exp(gamma[N])` scoring and repeated `exponential_lpdf(u[t] | ...)` / `exponential_lpdf(v[t] | ...)` terms inside loops. SafeStan requires protected observations to be scored exactly once using built-in sampling statements, and forbids arbitrary `target +=` scoring. Replacing this marginalized latent-state algorithm with SafeStan-compatible sampling statements would require a substantive model rewrite or a change to the likelihood, not a minor mechanical translation. The manual `target +=` prior terms could potentially be rewritten, but the HMM likelihood remains incompatible.
