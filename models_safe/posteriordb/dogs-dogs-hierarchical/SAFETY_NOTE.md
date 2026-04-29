# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the originally observed `y` array, with Stan-index relation `y_safestan_flat[(j - 1) * n_trials + t] = y[j, t]`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_flat` so the observed binary outcomes are represented by a top-level protected identifier and scored exactly once with a built-in Bernoulli distribution. The original `y` array is retained as context for the deterministic lag-count construction in `transformed data`; the supplied `data_safe.json` sets `y_safestan_flat` to the row-major flattening of `y`. The elementwise Bernoulli likelihood was vectorized into one sampling statement outside loops. Added density-neutral `a ~ uniform(0, 1)` and `b ~ uniform(0, 1)` statements for parameters already constrained to `[0, 1]`, satisfying SafeStan's unique-prior rule without changing the posterior density.
