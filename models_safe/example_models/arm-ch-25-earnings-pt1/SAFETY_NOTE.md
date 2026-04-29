# SafeStan Safety Note

Compatibility: major.

Protected data: `earnings`.

Generated files: none.

Reason: the observed likelihood is `earnings ~ bernoulli_logit(...)`, so `earnings` is the protected data variable. However, the parameter `beta` has no explicit prior in the original Stan program. SafeStan requires each parameter to have exactly one built-in prior sampling statement before it is used. Adding a proper prior to unconstrained `beta` would change the posterior/log density, and there is no same-density built-in prior corresponding to the original improper flat prior. Therefore this cannot be translated without a substantive density change.
