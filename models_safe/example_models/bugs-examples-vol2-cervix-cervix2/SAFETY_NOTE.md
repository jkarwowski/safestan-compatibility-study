# SafeStan Safety Note

Compatibility: minor.

Protected data: `xc`, `dc`, `wc`, `di`, and `wi`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the elementwise likelihoods that were inside loops into one top-level sampling statement for each protected data variable. Helper linear-predictor/probability vectors are computed only after the protected variables they depend on have been observed. Moved parameter priors before parameter use and replaced the nested elementwise `phi[i, j] ~ uniform(0, 1)` loop by the equivalent vectorized `phi ~ uniform(0, 1)`. The data JSON is unchanged and no data fields were added.
