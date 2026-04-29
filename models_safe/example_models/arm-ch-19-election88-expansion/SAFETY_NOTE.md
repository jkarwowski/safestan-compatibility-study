# SafeStan Safety Note

Compatibility: major.

Protected data: `y`, identified from the likelihood statement `y ~ bernoulli_logit(Xbeta)`.

Generated files: none.

Reason: the protected observation itself is a top-level data variable and is scored once, but the parameter side is not SafeStan-compatible. Several parameters have no built-in prior sampling statement, including the positive scale parameters `sigma_age_raw`, `sigma_edu_raw`, `sigma_region_raw`, `sigma_state_raw`, `sigma_age_edu_raw`, the positive multipliers `xi_age`, `xi_edu`, `xi_age_edu`, `xi_state`, and unused parameters such as `b_0`, `b_black`, `b_female`, and `b_female_black`. Some parameters are also used through transformed parameters or as prior scales before any prior could be assigned. Adding proper priors would change the posterior/log density, while the original improper flat priors cannot be represented by SafeStan sampling statements as a minor same-density rewrite.
