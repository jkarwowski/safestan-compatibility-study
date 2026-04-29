# SafeStan Safety Note

Compatibility: major.

Protected data: `cObs` is the top-level observed concentration data, but the model scores the transformed quantity `logCObs = log(cObs)`.

Generated files: none.

Reason: the original likelihood is applied to a transformed-data value (`logCObs ~ normal(...)`) rather than to a top-level protected data identifier. Rewriting this as a SafeStan observation of `cObs` would require changing the likelihood, for example to a lognormal likelihood with a Jacobian term, which is not the same log density. In addition, the parameter `ka` has no explicit proper built-in prior; adding one would change the posterior. Therefore a SafeStan-compatible version cannot be produced by only minor same-density mechanical changes.
