# SafeStan Safety Note

Compatibility: major.

Protected data choice: `earn` is the observed response scored by the likelihood. `height` is a context predictor and `N` is a size.

Generated files: none.

Reason: the model has parameters `beta` and `sigma` with no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for unconstrained `beta` or positive-constrained `sigma` would change the posterior/log density because these are implicit improper flat priors in the original Stan program, not finite bounded uniform priors that can be made explicit density-neutrally.
