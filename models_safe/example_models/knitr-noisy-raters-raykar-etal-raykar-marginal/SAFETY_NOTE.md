# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed rater outcomes `y` are conditioned on through a marginalized latent-class likelihood implemented with `target += log_sum_exp(...)` and branches inspecting `y[n, r]`. SafeStan forbids manual `target +=` scoring, and the protected observation would need to be scored exactly once by a built-in distribution with a plain top-level left-hand side. Replacing this marginalized noisy-rater likelihood with SafeStan sampling statements would require a substantive model rewrite, such as introducing an unavailable custom/marginal distribution or changing the latent-state representation, rather than a minor same-density translation.

Additional incompatibility: model-block computations use parameters before their prior sampling statements, which could be mechanically reordered, but the marginalized likelihood remains a major incompatibility.
