# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed outcome `kid_score` is scored once with the built-in `normal_id_glm` likelihood, while `mom_hs`, `mom_iq`, and `N` are context inputs. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before it is used in the model block. Adding proper priors would change the posterior/log density, and the existing implicit flat or half-flat priors are not finite bounded density-neutral built-in priors that can be mechanically added. Therefore a SafeStan-compatible translation would require a substantive density change.
