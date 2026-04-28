# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood scores `sqrt_dif`, a deterministic transformed-data vector computed from `score_1` and `score_2`.

Generated files: none.

Reason: although `sqrt_dif` could be made a top-level deterministic data augmentation, the model has parameters `sigma_a` and `sigma_y` with no prior sampling statements. Their only restrictions are lower bounds, which correspond to improper flat priors on positive reals. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors, or otherwise replacing these improper priors, would change the posterior/log density and is therefore a substantive model change rather than a minor SafeStan translation.
