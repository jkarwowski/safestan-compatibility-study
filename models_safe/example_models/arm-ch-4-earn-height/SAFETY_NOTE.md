# SafeStan Safety Note

Compatibility: major.

Protected data: `earn`.

Generated files: none.

Reason: `earn` is the observed response scored by the built-in likelihood `normal_id_glm`. However, the parameters `alpha`, `beta`, and `sigma` have no explicit priors in the original model. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors would change the posterior/log density, while the original implicit flat/improper priors cannot be represented as SafeStan-compatible built-in prior sampling statements by a minor same-density rewrite.
