# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood observes `switched` with a built-in `bernoulli_logit` sampling statement, but the parameter `beta` has no explicit prior. In the original Stan model this corresponds to an improper flat prior on an unconstrained vector. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding any proper built-in prior for `beta` would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
