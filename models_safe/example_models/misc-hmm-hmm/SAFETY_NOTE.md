# SafeStan Safety Note

Compatibility: minor.

Protected data: `w`, `z_tail`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `Tm1 = max(T - 1, 0)` and `z_tail = z[2:T]` as deterministic data augmentation for this supplied data. The original transition observations `z[t]` for `t >= 2` are protected through `z_tail`; `z[1]` and the original `z` array are retained as context for deterministic lag/state design matrices.

The looped/indexed categorical likelihoods were rewritten as single top-level sampling statements using built-in `categorical_logit_glm` distributions with one-hot design matrices and log simplex probabilities. This preserves the same likelihood because `softmax(log(theta[k])) = theta[k]` and `softmax(log(phi[k])) = phi[k]`. The looped Dirichlet priors over the arrays of simplexes were vectorized as top-level prior statements. No manual `target +=` scoring or user-defined distributions were introduced.
