# SafeStan Safety Note

Compatibility: major.

Protected data: `y` in the original model; it is the observed response array scored by the Bernoulli-logit likelihood.

Generated files: none.

Reason: the original model is an MLE-style model with unconstrained parameters `b` and `theta` and no priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors to these unconstrained parameters would change the posterior/log density, and there is no density-neutral proper built-in prior matching the original implicit flat density. The original likelihood also scores indexed rows `y[i]` inside a loop rather than a single protected top-level variable, which could require mechanical reshaping, but the missing-prior issue prevents a same-density SafeStan translation.
