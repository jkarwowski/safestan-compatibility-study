# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history matrix). `M` and `T` are context inputs.

Generated files: none.

Reason: the likelihood for `y` is implemented with manual `target +=` statements, including a `log_sum_exp` marginalization over the latent inclusion state for all-zero capture histories. The model also computes summaries and effective capture probabilities from `y` before any possible SafeStan observation. Representing this exact marginalized capture-history likelihood in SafeStan would require a substantive rewrite, such as replacing the marginalized latent-state algorithm with an enumerated categorical likelihood or another custom construction, rather than a minor mechanical translation.
