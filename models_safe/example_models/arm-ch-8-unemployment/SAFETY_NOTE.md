# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation `y` is scored once with the built-in `normal_id_glm` likelihood, but the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements before they are used in that likelihood. SafeStan requires every parameter to have exactly one built-in prior. Adding priors here would change the original posterior/log density because the original model uses implicit improper flat priors, so this is not a minor same-density rewrite.
