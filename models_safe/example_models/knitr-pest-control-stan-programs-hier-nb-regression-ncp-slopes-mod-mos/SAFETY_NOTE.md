# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with the built-in `neg_binomial_2_log` sampling statement. All other data variables are context inputs. Each parameter has exactly one built-in prior before the likelihood uses any transformed quantity depending on it.
