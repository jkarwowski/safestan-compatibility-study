# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal(...)`, so `kid_score` is the protected interface variable. That likelihood statement itself is SafeStan-shaped, and the predictors `mom_hs`, `mom_iq`, and derived interaction `inter` are ordinary context inputs. However, the parameter `beta` has no explicit prior in the original model and is used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for the unconstrained regression coefficients would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
