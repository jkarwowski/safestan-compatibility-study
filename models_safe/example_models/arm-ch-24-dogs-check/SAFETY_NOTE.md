# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_flat_safestan`, a deterministic row-major flattening of the original observed array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_flat_safestan` with relation `y_flat_safestan[(j - 1) * n_trials + t] = y[j, t]`. The original `y` is retained as context for the lagged avoidance/shock history, while the likelihood is represented by one plain top-level sampling statement `y_flat_safestan ~ bernoulli(p_flat_safestan)`. Replaced the loop of row-wise `beta_neg` multivariate-normal prior statements by an equivalent vectorized prior after changing `beta_neg` from a matrix to `array[n_dogs] vector[2]`, a one-to-one representation of the same parameters. Other priors and deterministic computations are unchanged.
