# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood-scored observation is `sqrt_dif`, a transformed-data vector computed deterministically as `2 * (step(score_1 - score_2) - 0.5) * sqrt(abs(score_1 - score_2))` from `score_1` and `score_2`. In a SafeStan rewrite this would need to be supplied as a top-level protected data variable.

Generated files: none.

Reason: the original model has parameters `b`, `sigma_a`, and `sigma_y` with only Stan's implicit improper flat priors, and SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density; representing the improper priors with SafeStan sampling statements is not an allowed same-density minor rewrite. Therefore no SafeStan-compatible translation preserving the model is produced.
