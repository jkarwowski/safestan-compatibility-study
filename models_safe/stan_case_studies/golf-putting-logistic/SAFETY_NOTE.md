# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observation `y ~ binomial(n, p)` is syntactically suitable for SafeStan, with `n`, `x`, `r`, `R`, and `J` acting as context inputs. However, the parameter `sigma` has no explicit built-in prior sampling statement before it is used to compute `p`. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for `sigma` would change the posterior/log density, and its `<lower=0>` constraint corresponds only to an improper positive-uniform density, not a proper finite-bound prior that can be made explicit density-neutrally. Therefore this cannot be translated with only a minor same-density rewrite.
