# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`. In `model_safe.stan`, `y` is the original `N x T` count array flattened in row-major order: `y[(n - 1) * T + t] = original_y[n, t]`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped protected count data `y` to a length `N * T` top-level array so it can be observed exactly once with the plain statement `y ~ poisson_log(eta)`, instead of indexed observations inside a loop. Reparameterized `b` from `array[N] vector[T]` to a length `N * T` vector with the same row-major indexing and placed its normal prior in a single top-level sampling statement. All other priors and deterministic centering computations are unchanged; the product Poisson likelihood and independent normal random-effect prior are the same after this deterministic reshape.
