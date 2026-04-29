# SafeStan Safety Note

Compatibility: major.

Protected data: `goal_difference` is the observed response scored by the likelihood in the Stan program.

Generated files: none.

Reason: the likelihood uses a user-defined `skellam_lpmf` distribution via indexed sampling statements inside a loop (`goal_difference[g] ~ skellam(...)`). SafeStan sampling statements must target protected top-level data with built-in Stan distributions, and protected observations cannot be scored inside loops or through user-defined distributions. Stan has no built-in Skellam distribution, so translating this exactly would require manual log-density scoring or a substantive latent-variable/model rewrite, which is outside a minor SafeStan translation.
