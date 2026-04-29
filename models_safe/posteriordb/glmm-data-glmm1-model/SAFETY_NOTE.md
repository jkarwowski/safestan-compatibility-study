# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the observed-count likelihood so the protected top-level data variable `obs` is scored exactly once with a plain sampling statement, outside the loop. Added `log_lambda_obs` as a deterministic transformed-parameter vector containing the same per-observation log rates used by the original loop. Reordered parameter priors so `mu_alpha` and `sd_alpha` are sampled before they are used in the prior for `alpha`. Added `sd_alpha ~ uniform(0, 5)`, matching the existing finite constraint on `sd_alpha` and making the original implicit bounded-uniform prior explicit for SafeStan. No data values were changed or added.
