# SafeStan Safety Note

Compatibility: major.

Protected data: none emitted. The model's observed likelihood is on `sqrt_dif`, a transformed-data quantity computed deterministically from `score_1` and `score_2`.

Generated files: none.

Reason: the sampling statement `sqrt_dif ~ student_t(...)` does not observe a top-level data variable; a minor rewrite could add a deterministic top-level protected copy of `sqrt_dif`. However, the parameters `b`, `sigma_a`, and `sigma_y` have no explicit built-in prior sampling statements in the original model. SafeStan requires each parameter to have exactly one built-in prior before use. Adding proper priors for these parameters would change the posterior/log density, and the original implicit flat priors are not proper built-in priors that can be added density-neutrally. Therefore no SafeStan-compatible version can be produced without a substantive density change.
