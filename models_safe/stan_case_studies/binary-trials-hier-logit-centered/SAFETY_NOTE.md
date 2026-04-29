# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in `binomial_logit` distribution using a plain sampling statement. Context data `N` and `K` are not protected. Each parameter (`mu`, `sigma`, and `alpha`) has exactly one built-in prior before later use.
