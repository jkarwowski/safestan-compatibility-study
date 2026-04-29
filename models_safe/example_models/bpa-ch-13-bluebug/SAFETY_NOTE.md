# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed detection-history response scored by the likelihood in the original model.

Generated files: none.

Reason: the likelihood is a marginalized single-season occupancy likelihood implemented with `target +=`, `log_sum_exp(...)`, and branching on `sum_y`, which is derived from the observed response. SafeStan forbids manual target increments and protected-data-dependent likelihood gating before observation. Replacing this with SafeStan sampling statements would require a substantive rewrite of the marginalized latent-state likelihood rather than a minor mechanical translation.
