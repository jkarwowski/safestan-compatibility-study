# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model scores the transformed response `log_earn = log(earn)`; `height`, `male`, and `N` are context inputs. A SafeStan rewrite would need a top-level protected observation for this response or an equivalent same-density representation.

Generated files: none.

Reason: the original model has top-level parameters `beta` and `sigma` with only implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these parameters would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite. The transformed-data likelihood target would also require a mechanical top-level protected-response rewrite, but the missing proper priors are already a substantive incompatibility.
