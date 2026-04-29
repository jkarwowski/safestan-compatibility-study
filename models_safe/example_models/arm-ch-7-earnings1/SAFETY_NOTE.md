# SafeStan Safety Note

Compatibility: major.

Protected data: `earn_pos`.

Generated files: none.

Reason: the observed likelihood is `earn_pos ~ bernoulli_logit_glm(x, alpha, beta)`, with `height` and `male` used only as context predictors through the transformed-data matrix `x`. However, the parameters `alpha` and `beta` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors would change the posterior/log density, and these unconstrained parameters do not have finite-bound implicit uniform priors that could be made explicit density-neutrally. Therefore this cannot be translated to SafeStan with only a minor same-density rewrite.
