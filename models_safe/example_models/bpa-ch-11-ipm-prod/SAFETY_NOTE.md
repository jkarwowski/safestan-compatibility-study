# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` and `m` are the observed data variables scored by the model likelihood.

Generated files: none.

Reason: this model is not mechanically translatable to the SafeStan subset. The latent state process scores parameter components inside loops, including indexed parameter statements such as `N1[1] ~ normal(...)`, `Nad[1] ~ normal(...)`, and looped transitions for `N1[t]` and `Nad[t]`. SafeStan requires each top-level parameter to have exactly one built-in prior sampling statement before use, not indexed or looped process-density statements. The transition densities use user-defined `_lpdf` distributions (`real_poisson_lpdf`, `real_binomial_lpdf`) and `reject()`, both rejected by SafeStan. The model also relies on implicit improper flat priors for positive parameters such as `sigma_y` and `mean_fec`; adding proper priors would change the posterior. Rewriting this as SafeStan-compatible would require a substantive change to the state-space model/density, not a minor same-density rewrite.
