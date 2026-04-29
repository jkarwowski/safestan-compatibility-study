# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observation `switched` is scored once with a built-in likelihood, but the parameters `alpha` and `beta` have no explicit priors before being used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for the unconstrained real/vector parameters would change the original posterior/log density, so this cannot be repaired as a minor same-density rewrite.
