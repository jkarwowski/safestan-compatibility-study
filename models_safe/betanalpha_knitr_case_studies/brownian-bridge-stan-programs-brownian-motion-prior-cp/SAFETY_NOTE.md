# SafeStan Safety Note

Compatibility: minor.

Protected data: none. `N`, `ts`, and `x_left` are context inputs; no top-level data variable is scored by a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original Brownian-motion prior was written as looped sampling statements on elements of the transformed parameter `xs`, which SafeStan does not allow for parameter priors. The safe model replaces those conditionals with one built-in `multi_normal_cholesky` prior on the top-level parameter `xs_forward`. The Cholesky factor is deterministic from `ts` and gives `Cov(xs_forward[i], xs_forward[j]) = ts[min(i,j) + 1] - ts[1]`, so the density is the same product of Gaussian transitions. `xs_forward` is represented as a vector to be the plain left-hand side of the multivariate prior, and `xs` is reconstructed deterministically. The data file is unchanged.
