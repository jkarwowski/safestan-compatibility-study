# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, with `y_safestan_copy[i] = y[i]`, so the empirical mean and standard deviation used by the original standardization can be computed without reading protected `y` before its observation. Replaced the transformed-data likelihood target `y_std ~ student_t(...)` with a single built-in sampling statement for top-level protected `y` on the original scale, using location `mu_std * y_sd + y_mean` and scale `sigma_std * y_sd`. This preserves the posterior of the standardized model; relative to scoring `y_std`, the original-scale statement includes only the data-only scale normalization needed for the normalized likelihood.
