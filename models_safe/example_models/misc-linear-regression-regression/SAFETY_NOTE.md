# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored `y[n]` inside a loop. SafeStan requires each protected top-level data variable to be observed exactly once with a plain identifier on the left-hand side of a built-in sampling statement, outside loops. The likelihood was mechanically vectorized to `y ~ normal(rep_vector(alpha, N) + beta * x, sigma);`, which preserves the same log density as the original product over `n`. No data changes were required.
