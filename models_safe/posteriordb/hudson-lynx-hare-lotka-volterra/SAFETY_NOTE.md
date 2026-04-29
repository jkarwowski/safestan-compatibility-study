# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_init`, `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the two observed-data likelihoods so each protected top-level data variable appears exactly once on the left-hand side of a built-in sampling statement outside any loop. The column-wise `y_init[k]` and `y[:, k]` lognormal likelihoods were replaced by equivalent vectorized statements using local helper arrays for `log(z_init)`, `log(z)`, and replicated measurement-error scales. The two indexed `theta` prior statements were replaced by one equivalent vectorized prior with deterministic prior-location and prior-scale arrays. No data values were changed or added.
