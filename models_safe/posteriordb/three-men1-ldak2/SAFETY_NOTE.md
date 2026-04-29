# SafeStan Safety Note

Compatibility: major.

Protected data: `w`. The `doc` array is treated as context/index data, not as an observed response scored by the likelihood.

Generated files: none.

Reason: the word likelihood is implemented by manually accumulating `target += log_sum_exp(gamma)` for each token, marginalizing over latent topic indicators. SafeStan forbids arbitrary `target +=` scoring. Replacing this marginalized LDA likelihood with SafeStan sampling statements would require a substantive likelihood/algorithm rewrite rather than a minor mechanical translation. The parameter priors are also written inside loops and would need restructuring, but the manual marginalized likelihood is the decisive incompatibility.
