# SafeStan Safety Note

Compatibility: major.

Protected data: the scored observation is the goal difference `dif`, computed in `transformed data` as `score_1 - score_2`; it is not a top-level data variable in the original program.

Generated files: none.

Reason: the likelihood is written as `dif ~ student_t(...)` where `dif` is transformed data, so it is not directly a SafeStan-protectable top-level input. That part could only be addressed by introducing a top-level deterministic difference variable. More importantly, parameters `b`, `sigma_a`, and `sigma_y` have no explicit built-in prior sampling statements. SafeStan requires every parameter to have exactly one prior before use, and adding proper priors for these parameters would change the posterior/log density because their original priors are implicit improper flat/half-flat constraints. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
