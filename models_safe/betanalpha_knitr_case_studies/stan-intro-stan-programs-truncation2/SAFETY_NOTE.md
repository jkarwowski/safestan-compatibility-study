# SafeStan Safety Note

Compatibility: minor.

Protected data: none; the program has no data block and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target +=` prior and truncation-normalization terms with equivalent built-in sampling statements. Specifically, `a ~ normal(0, 1)` replaces `normal_lpdf(a | 0, 1)`, and `x ~ normal(0, 1) T[a, ]` replaces `normal_lpdf(x | 0, 1) - normal_lccdf(a | 0, 1)` under the existing constraint `x >= a`. No data fields were added; `data_safe.json` remains `{}`.
