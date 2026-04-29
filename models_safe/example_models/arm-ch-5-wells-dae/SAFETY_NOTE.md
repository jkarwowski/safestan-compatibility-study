# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is the built-in sampling statement `switched ~ bernoulli_logit_glm(x, alpha, beta)`, with `x` deterministically computed from context inputs. However, the parameters `alpha` and `beta` have no explicit priors in the original model; they have only implicit improper flat priors. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors would change the posterior/log density, and there is no same-density built-in sampling statement for the original improper priors. Therefore this model cannot be translated to SafeStan with only a minor mechanical rewrite.
