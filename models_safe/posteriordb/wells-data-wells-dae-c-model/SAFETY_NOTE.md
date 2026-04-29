# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: `switched` is the modelled observation, but the model has unconstrained parameters `alpha` and `beta` with no prior sampling statements before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement. Adding proper priors would change the posterior/log density, and the original implicit improper flat priors on unbounded parameters are not a minor SafeStan-compatible rewrite.
