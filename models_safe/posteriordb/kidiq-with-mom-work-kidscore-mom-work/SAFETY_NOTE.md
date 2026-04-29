# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score` is the observed response scored by the likelihood. `mom_work` and `N` are context/configuration data.

Generated files: none.

Reason: the likelihood itself is a plain top-level sampling statement, but the parameters `beta` and `sigma` have no explicit priors. SafeStan requires every top-level parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for the unconstrained `beta` vector or the positive `sigma` parameter would change the posterior/log density relative to the original Stan model's implicit improper priors, so this cannot be a minor same-density rewrite.
