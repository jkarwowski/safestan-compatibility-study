# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the original response array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_flat` with deterministic relation `y_safestan_flat[(i - 1) * J + j] = y[i, j]` for Stan indices `i = 1:I` and `j = 1:J`. This is needed because the original model scored indexed slices `y[i]` inside a loop, while SafeStan requires the protected observation to be a top-level identifier scored exactly once. The likelihood was rewritten as one vectorized `bernoulli_logit` statement over the flattened responses, with linear predictors computed in the same row-major order. The parameter priors were already explicit and are unchanged.
