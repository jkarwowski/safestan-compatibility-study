# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed interface because it is the only top-level data variable on the left side of a sampling statement. The parameter `beta` has no prior sampling statement and is used in the likelihood, which violates SafeStan's requirement that every parameter have exactly one built-in prior before use. Adding a prior for `beta` would change the posterior/log density because the original model intentionally uses an implicit improper flat prior on the slopes. Therefore this cannot be translated by a minor same-density rewrite.
