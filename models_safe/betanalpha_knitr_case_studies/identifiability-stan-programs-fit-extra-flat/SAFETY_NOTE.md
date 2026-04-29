# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed data `y` is scored by the likelihood `y ~ normal(a, sigma)`, while `N` and `sigma` are context inputs. However, the parameters `a` and `b` have only implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for unconstrained real parameters, or removing the unused parameter `b`, would change the original Stan density/posterior rather than being a minor same-density rewrite.
