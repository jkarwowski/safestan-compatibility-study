# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr_j`, `marr_a`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the row-wise multinomial likelihood loop with vectorized top-level sampling statements, so each protected data variable is observed exactly once with a plain identifier on the left-hand side. Added explicit `uniform(0, 1)` priors for `mean_phijuv`, `mean_phiad`, and `mean_p`; these are density-neutral because the parameters are already constrained to `[0, 1]` and the original model documented these priors as implicit. The data are unchanged.
