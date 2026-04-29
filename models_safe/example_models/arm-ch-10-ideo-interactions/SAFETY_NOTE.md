# SafeStan Safety Note

Compatibility: major.

Protected data: `score1`.

Generated files: none.

Reason: the observed likelihood is a single built-in sampling statement, `score1 ~ normal_id_glm(cov, alpha, beta, sigma)`, so `score1` is the protected interface variable. However, the parameters `alpha`, `beta`, and `sigma` have no prior sampling statements before being used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement. Adding proper priors for these parameters would change the original posterior/log density, since the original model uses implicit improper flat priors rather than finite bounded priors with an exactly matching built-in density. Therefore this cannot be translated with only a minor same-density rewrite.
