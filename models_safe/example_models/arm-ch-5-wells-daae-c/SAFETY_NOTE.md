# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`. The other data variables (`N`, `dist`, `arsenic`, `assoc`, and `educ`) are context inputs used to construct predictors and are not themselves scored as observations.

Generated files: none.

Reason: the likelihood observation `switched ~ bernoulli_logit_glm(x, alpha, beta)` is syntactically compatible with SafeStan, but the parameters `alpha` and `beta` have only Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, so this cannot be translated with only a minor same-density rewrite.
