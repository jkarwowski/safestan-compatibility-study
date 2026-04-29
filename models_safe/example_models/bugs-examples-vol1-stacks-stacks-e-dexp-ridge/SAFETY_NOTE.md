# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the elementwise likelihood loop `Y[n] ~ double_exponential(mu[n], sigmasq)` with the equivalent vectorized built-in sampling statement `Y ~ double_exponential(mu, sigmasq)`. This observes the protected top-level data variable exactly once with a plain left-hand side and outside a loop, preserving the same summed log density. No data fields were added; `data_safe.json` is the supplied data unchanged.
