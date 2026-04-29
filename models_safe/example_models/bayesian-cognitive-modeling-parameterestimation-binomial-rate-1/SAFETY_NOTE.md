# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `k` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `k ~ binomial(n, theta);`. The other data variable `n` is context input used only as the binomial trial count. The parameter `theta` has exactly one built-in prior, `theta ~ beta(1, 1);`, before it is used in the likelihood.
