# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ binomial(n, p)`, so `y` is the protected interface variable. However, the parameter `sigma` is used to compute `p` without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. The original model relies on an implicit improper flat prior on `sigma` over `(0, infinity)`, and adding a proper built-in prior would change the posterior/log density. Therefore this cannot be translated with only a minor same-density rewrite.
