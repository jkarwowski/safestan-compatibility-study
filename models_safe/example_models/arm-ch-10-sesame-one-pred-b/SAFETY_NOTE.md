# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed response scored by the built-in likelihood `normal_id_glm`. However, the parameters `alpha`, `beta`, and `sigma` have no explicit priors before their use in the likelihood. Adding proper built-in priors would change the posterior/log density, and their implicit Stan priors are improper flat priors that cannot be represented as SafeStan-compliant built-in prior sampling statements. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
