# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `logCObs`, a transformed-data value computed as `log(cObs)`, so the underlying observed input is `cObs`. No valid `--sstan-protect` variable set is emitted for this major-incompatible case.

Generated files: none.

Reason: the model cannot be translated to SafeStan with only mechanical same-density changes. The parameter `ka` is used in the prediction `cHatObs` but has no prior sampling statement; adding any proper built-in prior for this unbounded positive parameter would change the posterior. In addition, the observation is scored after a non-copy transformation (`logCObs = log(cObs)`) rather than as a top-level protected variable on the left side of `~`; replacing it with `cObs ~ lognormal(...)` would add the log-Jacobian term and change the normalized likelihood.
