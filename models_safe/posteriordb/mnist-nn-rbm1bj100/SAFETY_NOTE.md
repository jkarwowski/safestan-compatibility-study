# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the indexed likelihood loop `y[n] ~ categorical_logit(...)` as one built-in `y ~ categorical_logit_glm(...)` sampling statement with identical logits. Moved all parameter priors before any model-block use of those parameters. Replaced `to_vector(alpha)` and `to_vector(beta)` prior left sides with top-level `alpha` and `beta` sampling statements, which give the same elementwise normal priors. No data fields were added; `data_safe.json` is the supplied data.
