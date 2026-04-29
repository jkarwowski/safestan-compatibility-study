# SafeStan Safety Note

Compatibility: major.

Protected data: `grade`.

Generated files: none.

Reason: the observed response variable is `grade`, but the original likelihood scores indexed elements `grade[response]` inside a loop rather than observing the protected top-level data variable exactly once. More importantly, several parameters and hyperparameters are not given SafeStan-compatible priors: `mu_first_difficulty`, `sigma_ability`, `sigma_first_difficulty`, and `sigma_step` have only implicit improper flat priors, and `difficulty` is scored through indexed component and difference expressions, including a prior statement inside a loop. Adding proper priors or substantially reparameterizing the hierarchical ordered-threshold prior would change the model or require a non-minor density-preserving rewrite. Therefore no SafeStan-compatible same-posterior translation is produced.
