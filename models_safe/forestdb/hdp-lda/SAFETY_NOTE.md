# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` word likelihood with a single built-in `categorical_logit_glm` sampling statement for the protected top-level observation `y`. The model computes document-word log probabilities deterministically from `local_weight` and `atom`, and uses a transformed-data one-hot encoding of the context index `doc`. Vectorized the Dirichlet priors for `local_weight` and `atom` so parameter prior sampling statements are top-level and outside loops. No fields were added to `data_safe.json`; the data are unchanged.
