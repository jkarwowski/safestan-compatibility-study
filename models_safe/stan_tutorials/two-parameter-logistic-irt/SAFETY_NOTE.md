# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once by the built-in `bernoulli_logit` distribution with a plain sampling statement. All parameters (`alpha`, `beta`, and `theta`) have built-in prior sampling statements before they are used in the model block. There are no forbidden direct target manipulations or likelihood-gating constructs.
