# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response `y` is scored once with the built-in likelihood `bernoulli_logit`, but the top-level parameter `gamma` has no prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for the unbounded regression coefficient `gamma` would change the posterior/log density, so this is not a minor same-density rewrite.
