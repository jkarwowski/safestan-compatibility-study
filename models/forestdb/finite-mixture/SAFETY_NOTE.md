# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a two-component Bernoulli mixture marginalized over latent component labels using manual `target += log_mix(...)` scoring with direct `bernoulli_lpmf` calls. Representing this under SafeStan plain observation statements would require a substantive latent-state/mixture rewrite or a change to the likelihood representation, so no same-density minor translation is available.
