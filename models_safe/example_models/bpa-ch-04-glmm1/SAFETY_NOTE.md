# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the observation model from indexed sampling statements inside a loop (`obs[i] ~ ...`) to a single top-level protected sampling statement (`obs ~ poisson_log(...)`) using a local predictor vector computed from context indices and parameters. Reordered priors so hyperparameters are sampled before being used in the prior for `alpha`. Added `sd_alpha ~ uniform(0, 5)`, matching the finite bounds on `sd_alpha` and making the implicit bounded uniform prior explicit for SafeStan. The data file is unchanged.
