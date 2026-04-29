# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, representing the original observed `y` as a deterministic row-major flattening.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scored slices `y[n]` inside a loop. SafeStan requires a protected observation to be a top-level data identifier scored exactly once and not from inside a loop, so the nested `y` data were reshaped into `y_safestan_flat` with `y_safestan_flat[(n - 1) * SAMPLES + s] = y[n, s]`. The model constructs the matching mean vector after all parameter priors and then scores `y_safestan_flat ~ normal(mu_safestan_flat, sigma_within)`. This preserves the same product of normal likelihood terms; priors and generated quantities are otherwise unchanged.
