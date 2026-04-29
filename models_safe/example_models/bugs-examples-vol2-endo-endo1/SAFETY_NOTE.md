# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y1_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored the transformed-data slice `Y[1]`, which is not a top-level plain data identifier. The SafeStan version lifts that deterministic observed slice to a top-level protected data variable `Y1_safestan`, with `Y1_safestan[i] = 1` for `i = 1, ..., I`. The transformed-data helper `est1m2` is computed directly; this is the only transformed quantity used by the likelihood and is equivalent to the original `est[1] - est[2]` construction for data where the original indexing is well-defined. The parameter prior on `beta` was already a single built-in prior and was left unchanged.

`data_safe.json` augments the supplied data with `Y1_safestan: [1, 1, 1]`, deterministically generated from `I = 3` and the original transformed-data assignment `Y[1, i] = 1`.
