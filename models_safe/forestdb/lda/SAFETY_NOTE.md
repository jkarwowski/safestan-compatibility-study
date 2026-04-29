# SafeStan Safety Note

Compatibility: minor.

Protected data: `word_safestan` (a deterministic token-level reshape of the original `counts` table). `token_doc` and the dimension variables are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original count likelihood used manual `target += counts[d, v] * log_sum_exp(...)`, which is not allowed in SafeStan. The safe model replaces `counts` by a canonical token expansion: `N_tokens = sum_{d,v} counts[d,v]`; for each document `d` and vocabulary item `v`, `token_doc` contains `d` and `word_safestan` contains `v`, repeated `counts[d,v]` times in lexicographic `(d, v)` order. Tabulating (`token_doc`, `word_safestan`) reconstructs the original counts. The single protected sampling statement `word_safestan ~ categorical(word_prob)` has log density equal to the original count-weighted likelihood. The Dirichlet priors for `theta` and `phi` were vectorized so each top-level parameter has exactly one built-in prior statement outside loops.
