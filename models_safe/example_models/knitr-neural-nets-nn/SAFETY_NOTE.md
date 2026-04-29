# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: no data fields were added or changed. The model-block priors were rewritten from `to_vector(alpha)` and `to_vector(beta)` to top-level parameter sampling statements and placed before any parameter-dependent likelihood computation. The indexed likelihood loop `y[n] ~ categorical_logit(...)` was replaced by the single built-in vectorized statement `y ~ categorical_logit_glm(tanh(x * alpha), rep_vector(0, K), beta)`, which uses the same logits as the original `rbm(x, alpha, beta)`. `yt` is context data used only in generated quantities and is not protected.
