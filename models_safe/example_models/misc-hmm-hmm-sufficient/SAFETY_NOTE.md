# SafeStan Safety Note

Compatibility: minor.

Protected data: `trans`, `emit`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level protected data variables `trans` and `emit`, computed deterministically from the supplied `z` and `w` exactly as in the original `transformed data` block. Here `trans[k1, k2]` counts transitions from category `k1` to category `k2`, and `emit[k, v]` counts occurrences of word `v` in category `k`. For the supplied data, `trans = [[0, 0], [0, 2]]` and `emit = [[0, 0, 0], [0, 1, 2]]`. Removed the transformed-data construction of these observed sufficient statistics and replaced looped/indexed Dirichlet priors and multinomial likelihoods with vectorized built-in sampling statements on top-level variables, preserving the original product density.
