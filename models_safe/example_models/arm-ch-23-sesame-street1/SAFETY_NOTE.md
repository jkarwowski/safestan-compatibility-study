# SafeStan Safety Note

Compatibility: minor.

Protected data: `yt`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so each parameter is given its built-in prior before any later use. Vectorized the group prior from indexed loop statements to `ag ~ multi_normal(...)`, and vectorized the protected data observation to the top-level statement `yt ~ multi_normal(...)`.

The original data likelihood used `yt[i, 2]` inside the mean for `yt[i]` before the observation statement. This was rewritten algebraically as the equivalent marginal bivariate normal for `(yt[i, 1], yt[i, 2])`: the residual transform `(yt1, yt2) -> (yt1 - b * yt2, yt2)` has unit Jacobian, so the corresponding transformed mean and covariance preserve the same log density without reading protected `yt` before scoring it.

No data fields were added or changed.
