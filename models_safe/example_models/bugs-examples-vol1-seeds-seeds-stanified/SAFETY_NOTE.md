# SafeStan Safety Note

Compatibility: as-is.

Protected data: `n`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The observed response `n` is a top-level data variable and is scored exactly once with the built-in `binomial_logit` distribution using a plain sampling statement. The remaining data variables (`I`, `N`, `x1`, and `x2`) are context inputs. All parameters have explicit built-in prior sampling statements before later use.
