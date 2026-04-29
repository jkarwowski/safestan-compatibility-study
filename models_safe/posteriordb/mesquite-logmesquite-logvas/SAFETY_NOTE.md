# SafeStan Safety Note

Compatibility: major.

Protected data: `weight` is the top-level data variable whose transformed value `log_weight = log(weight)` is scored by the likelihood.

Generated files: none.

Reason: the model cannot be made SafeStan-compatible by a minor same-density rewrite. The parameters `beta` and `sigma` have no explicit prior sampling statements; adding proper built-in priors would change the posterior, while their implicit flat/half-flat priors are not a minor SafeStan prior rewrite. In addition, the observed sampling statement scores transformed data (`log_weight`) rather than a top-level protected data variable, so preserving the exact original log density would require changing the protected data interface or likelihood representation.
