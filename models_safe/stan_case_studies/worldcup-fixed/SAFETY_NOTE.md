# SafeStan Safety Note

Compatibility: major.

Protected data choice: the observed likelihood is applied to `sqrt_dif`, a transformed-data response deterministically computed from `score_1` and `score_2` as `2 * (step(score_1 - score_2) - 0.5) * sqrt(abs(score_1 - score_2))`. A minor rewrite could make this a top-level protected data variable, but no complete SafeStan translation is generated.

Generated files: none.

Reason: the model has parameters `b`, `sigma_a`, and `sigma_y` with implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, and improper flat priors cannot be represented by SafeStan sampling statements. Therefore preserving the original density would require a substantive model change.
