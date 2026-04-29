# SafeStan Safety Note

Compatibility: minor.

Protected data: none; the program has no top-level data observations.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target +=` prior and truncation-normalization terms with the equivalent built-in truncated sampling statement `x ~ normal(0, 1) T[a, ];`. This preserves the same density for the constrained parameter `x` while satisfying SafeStan's requirement that parameters be scored by a built-in sampling statement and avoiding arbitrary `target +=` statements.
