# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is for `y`, but the model cannot be translated to SafeStan with only a same-density mechanical rewrite. In particular, the parameter `sigma` has no explicit prior; SafeStan requires every parameter to be sampled exactly once from a built-in prior before use, and adding any proper prior for this lower-bounded scale parameter would change the posterior density. Other issues, such as indexed likelihood statements for `y[n]` and looped/indexed priors for `gamma` and `beta`, could be mechanically vectorized, but the missing `sigma` prior prevents a minor SafeStan-compatible translation that preserves the model.
