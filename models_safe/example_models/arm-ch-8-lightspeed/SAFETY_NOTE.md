# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is the built-in sampling statement `y ~ normal(beta[1], sigma)`, so `y` is the protected data interface. However, both parameters are used in that likelihood without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before first use. Adding priors for the unconstrained `beta` and lower-bounded `sigma` would change the original posterior/log density, because their original Stan priors are implicit improper flat priors rather than proper finite-bound uniforms. Therefore this model cannot be translated with only a minor same-density rewrite.
