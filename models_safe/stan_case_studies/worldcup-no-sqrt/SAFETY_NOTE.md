# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model's observed likelihood is for the game-score difference `dif = score_1 - score_2`, which is computed in `transformed data` and then scored with `dif ~ student_t(...)`.

Generated files: none.

Reason: the model cannot be made SafeStan-compatible by a minor same-density rewrite. Although the transformed-data likelihood could in principle be mechanically exposed as a top-level protected difference or rewritten as a conditional likelihood for `score_1` given `score_2`, the parameters `b`, `sigma_a`, and `sigma_y` have no built-in prior sampling statements. SafeStan requires every parameter to have exactly one prior before use. Adding proper priors for these parameters would change the posterior/log density, because the original model only has implicit improper flat densities for them. Therefore this requires a substantive model change and is classified as major.
