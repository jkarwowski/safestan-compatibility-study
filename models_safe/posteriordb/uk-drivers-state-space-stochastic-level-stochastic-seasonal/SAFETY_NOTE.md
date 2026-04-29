# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed interface variable scored by `y ~ normal(...)`, while `n`, `x`, and `w` are context inputs. The model is not SafeStan-compatible because several parameter priors are expressed as indexed sampling statements inside loops (`seasonal[t] ~ ...` and `mu[t] ~ ...`), and some parameters or initial state components have only implicit improper flat priors (`beta`, `lambda`, early `seasonal` elements, and `mu[1]`). SafeStan requires each top-level parameter to have exactly one built-in prior before use and does not allow parameter-prior sampling statements inside loops. Preserving this latent state-space density would require a substantive reparameterization and/or adding priors that change the model. The additional issue that `y` is used in parameter bounds before observation could be handled by a deterministic copy, but that is insufficient to make the full model SafeStan-compatible.
