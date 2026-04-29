# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_proportion`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_proportion`, with deterministic relation `y_proportion[j] = y[j] / n[j]`, because the original likelihood scored the expression `to_vector(y) ./ to_vector(n)` and SafeStan requires a protected observation to be a plain top-level data identifier. The likelihood is otherwise unchanged. The three parameter priors were moved before the first model-block use of their parameters to satisfy SafeStan's prior-before-use rule.
