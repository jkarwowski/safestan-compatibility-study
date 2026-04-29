# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the original response array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored indexed slices `y[i]` inside a loop, which is not allowed for protected data in SafeStan. The rewrite adds `y_safestan_flat`, with `y_safestan_flat[(i - 1) * J + j] = y[i, j]`, builds the matching linear predictor vector in the model block after the parameter priors, and observes `y_safestan_flat` once with a plain built-in `bernoulli_logit` sampling statement. The priors on `theta` and `b` were already explicit built-in priors and are preserved unchanged.
