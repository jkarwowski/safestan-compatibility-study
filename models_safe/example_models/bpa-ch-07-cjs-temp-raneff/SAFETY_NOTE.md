# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the capture-history data scored by the likelihood in the original model; no SafeStan-compatible protected interface is generated.

Generated files: none.

Reason: the Cormack-Jolly-Seber likelihood is assembled from data-dependent first/last capture indices computed from `y`, conditional loops, indexed sampling statements such as `y[i, t] ~ bernoulli(...)`, and additional constant observations `1 ~ bernoulli(...)` for survival and uncaptured factors. SafeStan requires protected top-level data variables to be observed exactly once with plain built-in sampling statements, and sampling statements may not target indexed data or constants. Converting this model would require introducing derived event observations/indices or otherwise replacing the marginalized capture-history likelihood, which is beyond a minor same-density translation.
