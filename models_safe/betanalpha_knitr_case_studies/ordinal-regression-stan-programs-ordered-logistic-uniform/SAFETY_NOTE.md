# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed ordinal response `y` is scored once with the built-in `ordered_logistic` likelihood, but the parameters `gamma` and `c` have only implicit improper uniform/flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors to `gamma` or the ordered cut points `c` would change the posterior/log density, so this cannot be translated with only a minor same-density rewrite.
