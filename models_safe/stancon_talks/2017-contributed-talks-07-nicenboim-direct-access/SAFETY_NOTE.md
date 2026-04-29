# SafeStan Safety Note

Compatibility: major.

Protected data: `winner` and `RT`.

Generated files: none.

Reason: the likelihood for the observed choice and response-time data is implemented as manual `target += da(winner[n], RT[n], ...)` scoring inside a loop. The user-defined `da` function computes a custom marginalized joint likelihood involving categorical-logit terms, lognormal densities, and a mixture/backtracking calculation. SafeStan forbids arbitrary `target +=` scoring and requires protected observations to be scored exactly once by built-in sampling statements. Replacing this marginalized custom likelihood with SafeStan-compatible sampling statements would require a substantive model rewrite, such as introducing or otherwise handling latent mixture/backtracking states, and is not a minor same-density translation. Additionally, `RT` is used in transformed data to define `min_RT`, which would require a deterministic copy if the likelihood were otherwise compatible, but the custom marginalized likelihood is the blocking issue.
