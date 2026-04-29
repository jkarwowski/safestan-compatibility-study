# SafeStan Safety Note

Compatibility: minor.

Protected data: `x_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model used a user-defined `_lpdf` and a `target +=` loop to impose the Brownian-bridge prior on `interior_xs`, which SafeStan rejects. The safe model deterministically converts the same bridge normal factors into one built-in `multi_normal_prec` prior for the top-level parameter `interior_xs`; `interior_xs` is represented as a vector in the same interior-position order as `xs[2:(N - 1)]`. The protected observation likelihood `x_obs ~ normal(xs[obs_idxs], sigma)` is unchanged. No data fields were added or changed.
