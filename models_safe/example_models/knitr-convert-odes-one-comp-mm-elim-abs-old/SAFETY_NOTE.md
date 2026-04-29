# SafeStan Safety Note

Compatibility: minor.

Protected data: `C_hat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored indexed protected observations `C_hat[n]` inside a loop. SafeStan requires each protected data variable to be scored exactly once with a plain top-level identifier. The rewrite computes the array of log predicted concentrations after all parameter priors in the model block, then uses one vectorized built-in likelihood statement, `C_hat ~ lognormal(log_C, sigma);`. This is the same log density as the original product over measurement times. The data file is unchanged.
