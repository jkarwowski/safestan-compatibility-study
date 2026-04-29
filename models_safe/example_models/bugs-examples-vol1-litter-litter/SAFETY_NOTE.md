# SafeStan Safety Note

Compatibility: minor.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the beta prior for `p` and the binomial likelihood for `r` so that the protected observation is scored exactly once with a plain top-level sampling statement outside loops. Changed `p` from a bounded matrix to an equivalently indexed bounded two-dimensional array of reals to allow direct vectorized sampling as a top-level parameter. Added `mu ~ uniform(0, 1)`, which is density-neutral for a parameter already constrained to `[0, 1]` and satisfies SafeStan's unique-prior requirement. No data fields were added or changed.
