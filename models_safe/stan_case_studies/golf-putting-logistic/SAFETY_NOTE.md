# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y`, because it is the only top-level data variable appearing on the left side of a sampling statement (`y ~ binomial(n, p)`). The variables `n`, `x`, `r`, `R`, and `J` are context inputs.

Generated files: none.

Reason: the top-level parameter `sigma` is used in the likelihood but has no explicit built-in prior sampling statement. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding a proper prior for `sigma` would change the posterior/log density, and the existing lower bound `real<lower=0>` only implies an improper flat prior on the positive half-line, not a finite bounded uniform prior that can be added as a density-neutral mechanical rewrite.
