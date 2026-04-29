# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The program has no data block and no observed-data likelihood; the only scoring is a prior distribution over a latent covariance matrix.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original program scored a transformed parameter `W` with `W ~ wishart(4, S)` and added the change-of-variables term using `target += ...`, which is outside the SafeStan subset. The safe version declares `W` directly as a top-level `cov_matrix[2]` parameter and gives it the same built-in Wishart prior. The former scalar quantities `sd1`, `sd2`, `rho`, `cov`, and `x` are recovered deterministically from `W` in `transformed parameters`, so the induced distribution over those quantities matches the original manual parameterization. The data are unchanged (`{}`).
