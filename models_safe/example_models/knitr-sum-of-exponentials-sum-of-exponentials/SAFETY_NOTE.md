# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected observation `y` is scored by a top-level built-in sampling statement, but the parameters `a`, `b`, and `sigma` have no explicit priors and are used in the model likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior, while the existing lower-bound and ordered constraints only imply improper flat densities, so this cannot be made SafeStan-compatible by a minor same-density rewrite.
