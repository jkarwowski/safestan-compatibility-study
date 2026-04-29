# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scored `theta`, a transformed parameter, with `theta ~ uniform(0, 1)`, which SafeStan does not allow. Because `theta = inv_logit(alpha)`, that statement contributes the constant log density 0 for all finite `alpha`. The rewritten model removes that disallowed constant statement and adds the required top-level built-in prior `alpha ~ uniform(0, 1)` before `y` is observed; this makes explicit the same `[0, 1]` finite-density support required by `y ~ bernoulli(alpha)` and leaves the likelihood for the protected data unchanged. No data fields were added; `data_safe.json` is the supplied data.
