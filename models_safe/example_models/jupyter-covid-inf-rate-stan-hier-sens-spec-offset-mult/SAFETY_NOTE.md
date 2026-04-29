# SafeStan Safety Note

Compatibility: major.

Protected data: `y_sample`, `y_spec`, and `y_sens` are the observed data variables scored by likelihood sampling statements in the original model.

Generated files: none.

Reason: the original model relies on parameters without SafeStan-compatible priors, in particular the unbounded hyperparameters `mu_logit_spec` and `mu_logit_sens` have implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these parameters would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite. Other issues, such as prior ordering and the bounded `p` parameter's implicit uniform prior, would be mechanical, but the improper hyperpriors make the translation substantive.
