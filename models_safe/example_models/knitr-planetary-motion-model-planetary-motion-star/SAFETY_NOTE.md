# SafeStan Safety Note

Compatibility: minor.

Protected data: `q_obs_x`, `q_obs_y` (deterministic column split of the original observed `q_obs`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the original sliced likelihood statements `q_obs[ : , 1] ~ ...` and `q_obs[ : , 2] ~ ...` with likelihoods for two top-level protected arrays, because SafeStan requires protected observations to appear on the left side of `~` as plain identifiers exactly once. In `data_safe.json`, `q_obs_x` is the first column of the supplied `q_obs` and `q_obs_y` is the second column. Also split the original parameter array `p0` into scalar top-level parameters `p0_1` and `p0_2`, then reconstructed `p0` deterministically in `transformed parameters`, so each top-level parameter has exactly one built-in prior statement. These are mechanical same-density rewrites under the deterministic mapping.
