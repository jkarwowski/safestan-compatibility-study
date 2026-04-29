# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: `kid_score` is the observed response scored by the normal likelihood, while `mom_iq` and `N` are context inputs. The parameter `sigma` has a built-in prior, but the parameter `beta` has no sampling statement before it is used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for the unconstrained `beta` would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
