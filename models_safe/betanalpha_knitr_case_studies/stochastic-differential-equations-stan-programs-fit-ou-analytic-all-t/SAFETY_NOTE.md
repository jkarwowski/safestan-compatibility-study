# SafeStan Safety Note

Compatibility: major.

Protected data: `y_obs`.

Generated files: none.

Reason: `y_obs` is the observed data variable scored by the likelihood (`y_obs ~ normal(x[obs_idx], sigma)`). The latent state parameters are not SafeStan-compatible: `x_cp[n]` is sampled with an indexed left-hand side inside a loop, and its distribution depends on the transformed latent path `x`. SafeStan requires each top-level parameter variable to have a single built-in prior sampling statement outside loops before it is otherwise used. Preserving this OU latent-state density would require a substantive reparameterization or replacement of the centered/non-centered latent transition construction, not a minor mechanical rewrite.
