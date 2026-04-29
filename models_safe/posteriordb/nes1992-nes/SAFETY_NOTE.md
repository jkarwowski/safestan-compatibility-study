# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed response `partyid7` is scored by the likelihood statement `partyid7 ~ normal(...)`. However, the model has parameters `beta` and `sigma` with no explicit priors. SafeStan requires every parameter to be scored exactly once by a built-in prior before it is used in the model block. Adding proper priors for these parameters would change the posterior/log density, and the existing implicit priors are improper flat priors, not finite bounded uniform priors that can be made explicit by a density-preserving minor rewrite.
