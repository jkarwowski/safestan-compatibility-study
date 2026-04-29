# SafeStan Safety Note

Compatibility: minor.

Protected data: `X`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `X_safestan_copy`, a deterministic copy of `X`, because the original program reads `X` in `transformed data` to compute `g_bar` and `g_sigma` before `X` is observed. Vectorized the row-wise prior on `G` into one top-level sampling statement, added the density-neutral uniform simplex prior `F ~ dirichlet(rep_vector(1.0, I))` required by SafeStan for the simplex parameter array, and vectorized the likelihood so that the protected data variable `X` is observed exactly once with a plain top-level sampling statement. The `data_safe.json` file must be the supplied data augmented with `X_safestan_copy` exactly equal to `X` element-for-element.
