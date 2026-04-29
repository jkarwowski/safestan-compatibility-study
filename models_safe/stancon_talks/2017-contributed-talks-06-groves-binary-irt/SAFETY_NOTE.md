# SafeStan Safety Note

Compatibility: major.

Protected data: `grade`.

Generated files: none.

Reason: the observed interface variable `grade` is scored once with a built-in `bernoulli_logit` likelihood, but the model has top-level parameters `sigma_ability` and `sigma_difficulty` with no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these scale hyperparameters would change the posterior/log density, and their current lower-bound constraints do not provide a proper finite uniform prior that can be made explicit density-neutrally. Therefore this cannot be translated with only a minor same-density rewrite.
