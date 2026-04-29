# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for the five bounded scale parameters `sigma_a`, `sigma_b`, `sigma_c`, `sigma_d`, and `sigma_e`. These parameters already had finite bounds in the original Stan program, so the added uniform priors are the mechanical SafeStan-compatible representation of the original implicit bounded flat priors. The deterministic computation of `y_hat` was moved from `transformed parameters` into the `model` block after all parameter priors, so parameters are not used through `y_hat` before their SafeStan priors. The likelihood for the protected observation remains `y ~ bernoulli_logit(y_hat)` exactly once.

No data values or data declarations are changed; `data_safe.json` is the supplied `data_original.json` unchanged.
