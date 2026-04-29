# SafeStan Safety Note

Compatibility: minor.

Protected data: `z`, `w`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the `phi` Dirichlet prior so the top-level parameter is sampled once outside a loop, and vectorized the `z` likelihood as a single top-level protected-data sampling statement. Rewrote the word likelihood for `w` as one built-in `categorical_logit_glm` sampling statement using a one-hot topic design matrix computed after `z` is observed and `log(phi)` as logits. This preserves the density because `softmax(log(phi[k])) = phi[k]` for each simplex row. No data fields were added or changed.
