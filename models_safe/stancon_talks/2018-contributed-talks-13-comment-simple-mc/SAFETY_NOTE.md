# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `Y` is the only top-level data variable observed with a sampling statement, it is scored exactly once with the built-in `bernoulli_logit` distribution, and it is not used before observation. `X`, `A`, `N`, and `P` are context inputs. The parameter `alpha` has a single built-in prior before its transformed-parameter dependents are used in the likelihood.
