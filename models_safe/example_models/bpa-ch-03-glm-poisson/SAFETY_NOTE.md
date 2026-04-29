# SafeStan Safety Note

Compatibility: minor.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in uniform prior sampling statements for `alpha`, `beta1`, `beta2`, and `beta3`. These match the existing finite parameter bounds and preserve the original posterior density up to the same implicit bounded-support uniform priors. No data changes were required; `year` and `n` remain context inputs, and `C` is observed exactly once with the built-in `poisson_log` likelihood.
