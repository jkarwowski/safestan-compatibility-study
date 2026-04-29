# SafeStan Safety Note

Compatibility: major.

Protected data choice: the likelihood observes the transformed game-score difference `sqrt_dif`, computed deterministically from `score_1` and `score_2` in `transformed data`.

Generated files: none.

Reason: the transformed-data likelihood target could only be made SafeStan-compatible by adding a deterministic top-level protected copy of `sqrt_dif`, which would be a minor mechanical change. However, the parameters `sigma_a` and `sigma_y` have no explicit priors in the original model; their lower bounds imply improper half-flat densities. SafeStan requires each parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these scale parameters would change the posterior/log density, so this model cannot be translated without a substantive density change.
