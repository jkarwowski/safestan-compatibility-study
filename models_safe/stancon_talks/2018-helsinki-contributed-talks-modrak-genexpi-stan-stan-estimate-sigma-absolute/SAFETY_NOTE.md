# SafeStan Safety Note

Compatibility: major.

Protected data: the original model scores top-level data `expression` and `sigma_absolute_prior_sigma` with sampling statements.

Generated files: none.

Reason: the parameter `sigma_absolute` is used in the likelihood but never receives a built-in prior sampling statement. Its only prior contribution in the original Stan program is the implicit improper half-flat density from the `<lower=0>` constraint. SafeStan requires every parameter to have exactly one built-in prior before use; adding any proper prior would change the posterior/log density. Therefore a SafeStan-compatible translation cannot be produced by a minor same-density rewrite.
