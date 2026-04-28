# SafeStan Safety Note

Compatibility: major.

Protected data: the modelled observation is the match score differential `dif = score_1 - score_2`, which is computed from top-level data in `transformed data` and then scored by `dif ~ student_t(...)`.

Generated files: none.

Reason: the transformed-data likelihood target could be made top-level by a deterministic data augmentation, but the model also has parameters `b`, `sigma_a`, and `sigma_y` with no explicit built-in prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these parameters would change the original posterior/log density, because the original Stan model uses implicit improper flat priors. Therefore a SafeStan version preserving the same density is not a minor rewrite.
