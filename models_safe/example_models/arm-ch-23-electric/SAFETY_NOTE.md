# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in sampling statement `y ~ normal(y_hat, sigma_y);`. It is not referenced before observation or in transformed blocks. All parameters have exactly one built-in prior sampling statement before their use in the model block.
