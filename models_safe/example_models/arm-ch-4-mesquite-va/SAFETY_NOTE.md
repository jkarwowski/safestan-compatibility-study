# SafeStan Safety Note

Compatibility: major.

Protected data: the observed response is `weight`, but the model scores the transformed-data quantity `log_weight = log(weight)`. The other data variables (`N`, `diam1`, `diam2`, `canopy_height`, and `group`) are context inputs/predictors.

Generated files: none.

Reason: the likelihood is applied to a transformed-data variable rather than a protected top-level data variable, and the parameters `alpha`, `beta`, and `sigma` have no explicit built-in priors. Adding proper priors would change the posterior density, and the implicit flat priors here are not finite bounded uniforms that can be made explicit density-neutrally. Therefore a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
