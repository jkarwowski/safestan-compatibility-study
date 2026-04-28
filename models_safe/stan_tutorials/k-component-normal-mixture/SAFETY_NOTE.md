# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized finite normal mixture implemented by computing component log densities and then adding `target += log_mix(theta, ps)`. SafeStan forbids arbitrary `target +=` scoring and requires each protected data variable to be observed exactly once on the left-hand side of a built-in sampling statement. There is no mechanical same-density rewrite of this marginalized mixture into a single built-in sampling statement for `y`; introducing latent component allocations would change the model representation and posterior geometry and is not a minor SafeStan translation.
