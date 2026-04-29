# SafeStan Safety Note

Compatibility: minor.

Protected data: `w`. The variables `M`, `N`, `V`, and `doc` are context inputs used for sizes and indexing; they are not scored as observations.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` likelihood with an equivalent built-in categorical observation. The rewritten model deterministically forms `word_prob[n, v] = sum_k theta[doc[n], k] * phi[k, v]` and observes `w` once using vectorized `categorical`. The Dirichlet priors were vectorized so top-level parameters `theta` and `phi` each have exactly one built-in prior statement outside loops. No data fields were added or changed.
