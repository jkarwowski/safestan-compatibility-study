# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the only protected observation is the top-level data variable `y`, which is scored once by the built-in `multi_normal_cholesky` distribution. The original model computed parameter-dependent covariance matrices before the parameter priors, which violates SafeStan's parameter-use ordering rule. The safe version declares those local matrices first, places the existing built-in priors for `rho`, `alpha`, and `sigma` before any parameter-dependent computation, then computes the covariance and scores `y`. This is a mechanical reordering that preserves the posterior/log density. No data fields were added or changed; `data_safe.json` equals the supplied data.
