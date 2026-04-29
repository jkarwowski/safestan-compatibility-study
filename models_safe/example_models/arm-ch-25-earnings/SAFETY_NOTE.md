# SafeStan Safety Note

Compatibility: major.

Protected data choice: `earnings`. The remaining data variables (`N`, `male`, `over65`, `white`, `immig`, `educ_r`, `workmos`, `workhrs_top`, `any_ssi`, `any_welfare`, `any_charity`) are context inputs used as predictors or dimensions.

Generated files: none.

Reason: the observed likelihood is already a plain built-in sampling statement, `earnings ~ normal(...)`, but the parameters `beta` and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors for `beta` or `sigma` would change the posterior/log density; their original Stan priors are implicit improper flat priors, not finite bounded implicit proper priors that can be made explicit by a minor same-density rewrite.
