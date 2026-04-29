# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `Y`, which is observed exactly once with a plain built-in `student_t` sampling statement after all parameters have received built-in priors. The covariates `x` and size variables `N` and `p` are context data and are not protected.
