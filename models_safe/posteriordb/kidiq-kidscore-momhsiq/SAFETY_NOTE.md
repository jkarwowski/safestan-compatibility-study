# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the likelihood observation `kid_score ~ normal(...)` is a plain top-level data sampling statement, and `mom_hs`/`mom_iq` are context predictors. However, the parameter `beta` has no prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for unconstrained `beta` would change the posterior/log density, and there is no density-neutral built-in prior corresponding to Stan's implicit improper flat prior on an unconstrained vector. Therefore this cannot be translated without a substantive model change.
