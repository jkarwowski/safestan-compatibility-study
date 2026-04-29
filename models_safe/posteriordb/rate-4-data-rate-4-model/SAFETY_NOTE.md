# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `k` is a top-level data variable and is observed exactly once with the built-in sampling statement `k ~ binomial(n, theta);`. The data variable `n` is context for the binomial trial count and is not protected. Both parameters have explicit built-in priors before any model-block use.
