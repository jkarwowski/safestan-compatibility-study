# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the modelled observation, because it is the only top-level data variable on the left side of a sampling statement. `n`, `x`, and `w` are context inputs.

Generated files: none.

Reason: the original model is a latent state-space model whose state evolution is encoded through indexed parameter sampling statements inside loops (`seasonal[t] ~ ...` and `mu[t] ~ ...`). SafeStan requires parameter priors to be single built-in sampling statements on top-level parameter identifiers, not indexed statements in loops. Several parameters or initial state components also have no proper built-in prior (`beta`, `lambda`, `seasonal[1:11]`, and the initial level component), and `sigma` is used before its prior. In addition, the protected observation `y` is used in parameter bounds before being observed. While the data-dependent bounds could be handled by a deterministic copy, making the full model SafeStan-compatible would require a substantive reparameterization of the latent state process and adding priors for parameters with implicit flat priors, which would change the model/density rather than being a minor same-density rewrite.
