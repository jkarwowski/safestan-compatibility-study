# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed data variable scored by the model likelihood in `y ~ gpareto(ymin, k, sigma)`. The other data variables (`N`, `Nt`, `ymin`, and `yt`) are sizes, constants, or prediction inputs and are not scored as observations.

Generated files: none.

Reason: the likelihood is a user-defined generalized Pareto distribution (`gpareto_lpdf`) used through a sampling statement. SafeStan permits protected observations to be scored only by built-in Stan distributions, and this model also defines/calls user-defined distribution functions and uses `reject()` inside those functions. In addition, the parameters `sigma` and `k` have no explicit proper built-in priors; adding priors would change the posterior. Replacing the custom likelihood and parameter treatment would therefore be a substantive model change rather than a minor SafeStan translation.
