# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` token likelihood with a single built-in `categorical_logit_glm` sampling statement for `y`. The transformed data matrix `doc_onehot` and transformed parameter matrix `log_doc_prob` deterministically compute the same document-specific mixture probabilities implied by `local_weight` and `atom`. Vectorized the Dirichlet priors for `local_weight` and `atom` so each top-level parameter is assigned exactly one built-in prior outside loops. No data fields were added or changed.
