# SafeStan Safety Note

Compatibility: major.

Protected data: `cObs` is the intended observed interface; the model scores `logCObs`, a transformed-data value computed as `log(cObs)`.

Generated files: none.

Reason: a SafeStan translation would require substantive density changes. The likelihood is applied to `logCObs ~ normal(...)`, not to a top-level protected data identifier; scoring `cObs` directly with a built-in distribution such as `lognormal` would add the log-Jacobian term and change the original log density, while adding a new protected log-transformed observation is not a deterministic copy/reshape of the supplied top-level observation. In addition, parameter `ka` has no prior in the model; SafeStan requires every parameter to have exactly one built-in prior, and adding a proper prior for the lower-bounded `ka` would change the posterior.
