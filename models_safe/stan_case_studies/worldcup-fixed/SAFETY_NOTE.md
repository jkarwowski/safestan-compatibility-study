# SafeStan Safety Note

Compatibility: major.

Protected data: the model observes `sqrt_dif`, a transformed-data quantity computed deterministically from `score_1` and `score_2`.

Generated files: none.

Reason: the likelihood statement is `sqrt_dif ~ student_t(...)`, but `sqrt_dif` is not a top-level data variable. More importantly, parameters `b`, `sigma_a`, and `sigma_y` have only Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these parameters would change the posterior/log density, so this cannot be translated with only a minor same-density rewrite.
