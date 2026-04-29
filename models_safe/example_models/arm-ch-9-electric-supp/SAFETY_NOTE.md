# SafeStan Safety Note

Compatibility: major.

Protected data: `post_test`.

Generated files: none.

Reason: the likelihood is a built-in sampling statement for `post_test`, but the parameters `alpha`, `beta`, and `sigma` have no prior sampling statements before they are used. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for these unconstrained or half-constrained parameters would change the original posterior/log density, so this cannot be translated with a minor same-density rewrite.
