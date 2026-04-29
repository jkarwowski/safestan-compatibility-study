# SafeStan Safety Note

Compatibility: major.

Protected data: `post_test`.

Generated files: none.

Reason: `post_test` is the observed response scored by the likelihood, while `treatment` is an ordinary predictor/context input. The model has parameters `beta` and `sigma` that are used in the likelihood without any prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for the unconstrained `beta` and positive `sigma` would change the posterior/log density, because the original Stan program relies on implicit improper flat priors. Therefore this cannot be translated with only a minor same-density rewrite.
