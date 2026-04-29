# SafeStan Safety Note

Compatibility: major.

Protected data: `weight`.

Generated files: none.

Reason: the likelihood observes `weight` with a built-in normal sampling statement, but the model has parameters `a`, `b`, and `sigma` with no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for these unconstrained or half-line constrained parameters would change the original posterior/log density, so this cannot be translated by a minor same-density rewrite.
