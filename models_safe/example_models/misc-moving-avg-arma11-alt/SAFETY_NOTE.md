# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the ARMA(1,1) innovation likelihood from repeated sampling of the model-local residual `err` into a single equivalent built-in `multi_normal_cholesky` observation statement for the top-level protected variable `y`. The Cholesky factor is the deterministic lower-triangular map from independent innovations to observations, so the Jacobian determinant is 1 and the log density is the same as the original product of normal innovation densities. The data declaration for `y` was changed from `array[T] real` to `vector[T]` so it can be observed directly by `multi_normal_cholesky`; the supplied JSON array is unchanged and no new data fields were added.
