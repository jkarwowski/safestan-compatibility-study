# SafeStan Safety Note

Compatibility: minor.

Protected data: `X_safestan_flat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed likelihood statements for `X[i, j]` inside loops with a single top-level protected observation `X_safestan_flat ~ poisson_log(eta_safestan_flat)`. `X_safestan_flat` is a deterministic flattening of the original `X` in the same nested loop order used by the model: `for (i in 1:I) for (j in 1:J) for (k in 1:K)`. The original `X` is retained as unprotected context data for traceability but is not used by the model.

The priors on transformed-parameter aliases (`alpha`, `beta`, `gamma`) and indexed `lambda` entries were rewritten as equivalent vectorized priors on the corresponding top-level parameters: `alpha0`, `beta0`, `gamma0`, and `lambda`. This preserves the same posterior density while satisfying SafeStan's requirement that each parameter be given exactly one built-in prior sampling statement outside loops.
