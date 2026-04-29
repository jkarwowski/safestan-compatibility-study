# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `sqrt_dif`, a transformed-data quantity computed from `score_1` and `score_2`; there is no valid top-level protected data variable in the original program.

Generated files: none.

Reason: the model is not SafeStan-compatible without substantive changes. In addition to the likelihood being placed on a transformed-data value rather than a top-level protected observation, the parameters `sigma_a` and `sigma_y` have no built-in prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these positive scale parameters would change the posterior/log density, so this cannot be handled as a minor same-density rewrite.
