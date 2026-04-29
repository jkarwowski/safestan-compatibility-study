# SafeStan Safety Note

Compatibility: major.

Protected data: the observed response is `log_weight`, computed in `transformed data` as `log(weight)` from the top-level data variable `weight`. `N`, `diam1`, `diam2`, and `canopy_height` are context inputs used to build the predictor matrix.

Generated files: none.

Reason: the likelihood scores a transformed-data variable rather than a plain top-level protected data variable, and the parameters `alpha`, `beta`, and `sigma` are used in the likelihood with only implicit improper flat priors. SafeStan requires protected observations to be top-level data variables observed exactly once, and every parameter to have exactly one built-in prior before use. Adding proper priors, or changing the observation interface such as replacing the likelihood with a lognormal model for `weight`, would change the model/log density. Therefore no minor same-density SafeStan rewrite is available.
