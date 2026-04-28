# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ binomial_logit(K, alpha)`, after all parameters have received their priors. Context data `N` and `K` are used only as size/trial inputs. The extra JSON fields `y_new` and `K_new` are preserved exactly from the original data file and are not declared or used by the Stan program.
