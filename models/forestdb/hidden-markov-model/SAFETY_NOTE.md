# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed sequence likelihood, but it is scored through a marginalized hidden-state forward algorithm using direct `categorical_lpmf(...)` terms and a final `target += log_sum_exp(...)` contribution. Replacing this with plain SafeStan sampling statements would require changing the latent-state marginalization/likelihood representation, so this is not a minor same-density mechanical rewrite.
