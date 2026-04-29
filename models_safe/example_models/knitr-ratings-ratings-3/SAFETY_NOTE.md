# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation `y` is scored with a built-in normal likelihood, but several parameters used in that likelihood (`mu`, `sigma_a`, `sigma_b`, and `sigma_y`) have no explicit prior sampling statement in the original Stan program. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these parameters would change the posterior/log density, and the original implicit improper priors cannot be represented as a minor same-density SafeStan rewrite. The existing `alpha` and `beta` priors could be mechanically reordered before the likelihood, but the missing priors make the translation substantive.
