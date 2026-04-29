# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores the game score difference `dif = score_1 - score_2`, which is currently computed in `transformed data`; a SafeStan rewrite would need a top-level deterministic protected copy such as `dif`.

Generated files: none.

Reason: the model has parameters `b`, `sigma_a`, and `sigma_y` with no explicit built-in prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these parameters would change the posterior/log density, and the existing implicit flat priors are not finite proper priors that can be represented by a density-neutral built-in sampling statement. Therefore this cannot be translated with only minor same-density changes.
