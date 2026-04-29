# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in sampling statement `y ~ bernoulli_logit_glm(x, beta0, beta);`. The remaining data variables are context inputs. Each top-level parameter has exactly one built-in prior sampling statement before the likelihood uses the transformed coefficient vector `beta`.
