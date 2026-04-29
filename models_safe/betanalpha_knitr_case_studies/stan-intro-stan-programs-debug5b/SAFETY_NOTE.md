# SafeStan Safety Note

Compatibility: minor.

Protected data: none; the program has no data block and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of elementwise parameter prior statements `x[n] ~ normal(0, 1)` with the equivalent vectorized top-level prior statement `x ~ normal(0, 1)`. This preserves the same product standard-normal prior density while satisfying SafeStan's requirement that a parameter prior sampling statement target the top-level parameter exactly once and not occur inside a loop. The data file remains the empty JSON object.
