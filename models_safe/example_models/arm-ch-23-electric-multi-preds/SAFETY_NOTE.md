# SafeStan Safety Note

Compatibility: major.

Protected data: `post_test`.

Generated files: none.

Reason: `post_test` is the only top-level data variable observed with a sampling statement; `pre_test` and `treatment` are predictors and `N` is a size. The likelihood statement itself is a built-in distribution on a plain top-level data variable, but the parameters `beta` and `sigma` have no prior sampling statements before they are used. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for the unconstrained `beta` and lower-bounded `sigma` would change the posterior/log density rather than be a minor same-density rewrite.
