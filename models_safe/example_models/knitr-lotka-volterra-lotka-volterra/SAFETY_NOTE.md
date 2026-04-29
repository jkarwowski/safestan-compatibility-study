# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_init`, `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the two indexed observation loops into one top-level sampling statement for `y_init` and one top-level sampling statement for `y`, using model-local deterministic helper arrays for the log means and repeated scales. Rewrote the two indexed subset priors for `theta` as one vectorized built-in normal prior with element-specific means and standard deviations. No data fields were added or changed; `data_safe.json` is the supplied data.
