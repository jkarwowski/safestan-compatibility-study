# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response `y` is the only data variable scored by a sampling statement (`y ~ normal_id_glm(...)`). The predictor variables are ordinary context inputs. However, the parameters `alpha`, `beta`, and `sigma` have no prior sampling statements before being used in the likelihood. SafeStan requires each top-level parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these parameters would change the posterior/log density, and there are no finite bounded implicit uniform priors that could be made explicit density-neutrally. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
