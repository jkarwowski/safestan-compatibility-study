# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected observations `y[n]` are scored through a marginalized two-component Bernoulli mixture using manual `target += log_mix(...)` with direct `bernoulli_lpmf` calls. Replacing this with SafeStan plain sampling statements would require a substantive change to the likelihood or latent-component representation rather than a small mechanical rewrite.
