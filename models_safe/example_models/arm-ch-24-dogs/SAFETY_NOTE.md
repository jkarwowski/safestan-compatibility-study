# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_obs`, a deterministic row-major flattening of the original observed `y` array.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_obs` because the original model scored indexed elements of `y` inside loops, while SafeStan requires each protected variable to be scored exactly once with a plain top-level identifier. The original `y` remains as context data for the lagged history computations in `transformed parameters`, and `y_safestan_obs[(i - 1) * n_trials + t] = y[i, t]`. The likelihood was vectorized as `y_safestan_obs ~ bernoulli_logit(p_safestan_obs)`, where `p_safestan_obs` is the matching row-major flattening of `p`. The prior on `beta` was already SafeStan-compatible.
