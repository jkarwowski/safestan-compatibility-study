# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score` is the observed response scored by the normal likelihood. `mom_hs` and `mom_iq` are context predictors used to form centered covariates and an interaction; `N` is a size.

Generated files: none.

Reason: the likelihood statement itself is compatible in shape, but the model has parameters `beta` and `sigma` with no explicit prior sampling statements. SafeStan requires each parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for unconstrained `beta` or positive `sigma` would change the posterior/log density relative to the original model's implicit improper flat priors, so this cannot be represented by a minor same-density rewrite.
