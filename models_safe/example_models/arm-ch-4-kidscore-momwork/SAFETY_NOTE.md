# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the likelihood is the built-in statement `kid_score ~ normal_id_glm(x, alpha, beta, sigma)`, so `kid_score` is the protected interface variable while `N` and `mom_work` are context inputs. However, the parameters `alpha`, `beta`, and `sigma` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the original flat/improper-prior posterior, so this is not a minor same-density rewrite.
