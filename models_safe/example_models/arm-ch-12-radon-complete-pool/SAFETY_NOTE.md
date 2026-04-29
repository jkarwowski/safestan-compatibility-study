# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response `y` is scored once with the built-in `normal_id_glm` likelihood and is otherwise SafeStan-shaped. However, the parameters `alpha` and `beta` are used in that likelihood without explicit prior sampling statements. The original Stan model therefore relies on implicit improper flat priors for these unconstrained parameters. SafeStan requires every parameter to have exactly one built-in prior before use, and adding proper priors for `alpha` or `beta` would change the posterior/log density. This cannot be repaired by a minor same-density rewrite.
