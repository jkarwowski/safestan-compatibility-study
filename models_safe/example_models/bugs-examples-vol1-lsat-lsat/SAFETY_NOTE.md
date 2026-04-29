# SafeStan Safety Note

Compatibility: minor.

Protected data: `r_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `r_safestan`, a deterministic flattened copy of the expanded response array that the original `transformed data` block constructed as `r`. For pattern index `i` and respondent index `j` in the cumulative range encoded by `culm`, `r_safestan[(k - 1) * N + j] = response[i, k]`. For the supplied data this gives `[2, 2, 4, 4, 4, 4]`.

The likelihood was rewritten from a loop over indexed transformed data (`r[k] ~ bernoulli_logit(...)`) to a single built-in sampling statement with a plain top-level protected data variable: `r_safestan ~ bernoulli_logit(eta)`. The linear predictor `eta` is built after the parameter priors, preserving the same product of Bernoulli-logit factors as the original model.
