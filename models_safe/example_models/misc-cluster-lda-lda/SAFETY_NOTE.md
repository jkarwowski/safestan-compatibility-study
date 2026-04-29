# SafeStan Safety Note

Compatibility: minor.

Protected data: `w`. The document ids `doc`, sizes, and hyperparameters `alpha`/`beta` are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the Dirichlet priors for the top-level parameters `theta` and `phi` so each parameter has one prior sampling statement outside loops. Replaced the manual `target += log_sum_exp(...)` marginalized topic likelihood with deterministic word-probability vectors and one built-in categorical observation statement, `w ~ categorical(word_prob)`. This preserves the same likelihood because `word_prob[n, v] = sum_k theta[doc[n], k] * phi[k, v]`, so the categorical probability of `w[n]` equals the original marginalized topic probability. No data fields were added; `data_safe.json` is unchanged except for JSON formatting.
