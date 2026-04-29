# SafeStan Safety Note

Compatibility: major.

Protected data: `score1`.

Generated files: none.

Reason: the observed response `score1` is scored by a built-in likelihood, but the model has parameters `alpha`, `beta`, and `sigma` with no explicit priors. SafeStan requires each parameter to have exactly one built-in prior sampling statement before use. Adding priors for these unconstrained or half-line-constrained parameters would change the posterior/log density rather than being a minor same-density rewrite.
