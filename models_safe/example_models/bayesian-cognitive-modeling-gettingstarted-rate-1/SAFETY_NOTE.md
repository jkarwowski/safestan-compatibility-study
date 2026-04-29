# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The observed count `k` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `k ~ binomial(n, theta)`. The data variable `n` is context data used as the binomial trials count and is not protected. The parameter `theta` has exactly one built-in prior, `theta ~ beta(1, 1)`, before it is used in the likelihood.
