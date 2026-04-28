# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation model is a direct built-in likelihood (`y ~ neg_binomial(alpha, beta)`), but SafeStan also requires every parameter to have exactly one built-in prior before use. The parameter `alpha` has only an implicit improper flat prior on `[0, infinity)`. Adding any proper built-in prior for `alpha` would change the posterior/log density, so this cannot be translated with only a minor same-density rewrite.
