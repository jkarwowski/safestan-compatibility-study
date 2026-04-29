# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the parameter priors into SafeStan-compatible top-level sampling statements. The item-level prior `xi[i] ~ multi_normal_cholesky(...)` was vectorized to `xi ~ multi_normal_cholesky(...)` outside the loop. The separate indexed priors for `mu` and `tau` were combined into whole-parameter vectorized built-in priors with the same product density. The computation of `L_Sigma` was moved after the priors for `tau` and `L_Omega`, so those parameters are not used before their priors. The likelihood for the protected observation `y` is unchanged and remains a single top-level sampling statement. No data fields were added or changed.
