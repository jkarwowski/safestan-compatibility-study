# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `k` is a top-level data variable and is observed exactly once with the built-in `binomial` distribution. The context input `n` is used only as the binomial trial count, and parameter `theta` has a single built-in prior before it is used in the likelihood.
