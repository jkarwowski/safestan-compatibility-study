# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation model itself is a simple built-in likelihood, `y ~ binomial(n, p)`, with `y` as top-level data. However, the model has a positive parameter `sigma` with no explicit prior. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use in the model block. The original Stan program therefore represents an implicit improper flat prior on `sigma` over `(0, infinity)`. Adding any proper built-in prior would change the posterior/log density, and there is no density-preserving minor rewrite using SafeStan sampling statements for this improper prior.
