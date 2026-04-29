# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood scored `col(y, t)` inside a loop, so the protected observation was not a plain top-level identifier and was scored multiple times. The SafeStan version reshapes the original `matrix[N, T] y` into a protected `vector[N * T] y` in Stan column-major order, with `y[n + (t - 1) * N] = original_y[n, t]`, constructs the matching mean vector after all parameter priors, and observes `y` once with a built-in `normal` sampling statement. This is a deterministic reshape and preserves the same product normal likelihood.
