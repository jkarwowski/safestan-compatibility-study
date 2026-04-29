# SafeStan Safety Note

Compatibility: minor.

Protected data: none. `N`, `N_edges`, `node1`, and `node2` are context graph inputs used to define the prior precision structure; the original model does not observe or score any top-level data variable as a likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the forbidden manual `target +=` prior contribution and the expression-left-hand-side statement `sum(phi) ~ normal(...)` with a single built-in prior statement, `phi ~ multi_normal_prec(...)`. The precision matrix is built deterministically in `transformed data` as the graph Laplacian from `node1`/`node2` plus the soft sum-to-zero precision `(1 / square(0.01 * N)) * 1 1'`. This gives the same unnormalized log density in `phi` as the original model, up to constants independent of `phi`. No data fields were added or changed.
