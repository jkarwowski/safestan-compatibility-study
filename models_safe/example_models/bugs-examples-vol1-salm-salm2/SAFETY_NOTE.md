# SafeStan Safety Note

Compatibility: minor.

Protected data: `y` (a deterministic dose-major flattening of the original two-dimensional count array).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model observed `y[dose]` inside a loop and assigned the prior to `lambda[dose]` inside the same loop; SafeStan requires protected observations and parameter priors to be top-level sampling statements outside loops. The safe model reshapes `y` to `array[Ndoses * Nplates] int` with `y[(dose - 1) * Nplates + plate] = original_y[dose][plate]`, re-indexes the latent plate effects `lambda` as a vector in the same order, builds `eta` after all priors, and uses one `y ~ poisson_log(eta)` statement. No new observations were introduced; `Ndoses`, `Nplates`, and `x` are unchanged. Priors for `alpha`, `beta`, `gamma`, `tau`, and `lambda` remain the same built-in distributions, so the posterior/log density is preserved under the deterministic re-indexing.
