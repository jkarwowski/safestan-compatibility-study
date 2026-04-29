# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed response `partyid7` is scored by a built-in normal likelihood, but the parameters `beta` and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors to the unconstrained `beta` vector or positive `sigma` would change the posterior/log density, and these implicit improper priors cannot be represented as a minor density-preserving rewrite.
