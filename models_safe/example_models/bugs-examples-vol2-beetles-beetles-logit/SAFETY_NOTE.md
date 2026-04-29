# SafeStan Safety Note

Compatibility: as-is.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `r` is a top-level data variable and is observed exactly once with the built-in sampling statement `r ~ binomial_logit(n, m);`. Context data `N`, `n`, and `x` are not protected: `n` supplies binomial trial counts, `x` is used as a predictor, and `N` is a size. Parameters `alpha_star` and `beta` each have exactly one built-in prior before the likelihood uses the transformed parameter `m` that depends on them.
