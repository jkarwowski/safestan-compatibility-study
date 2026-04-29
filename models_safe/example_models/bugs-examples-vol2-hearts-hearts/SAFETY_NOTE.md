# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_cat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the original 0-based observed count array `y` by the deterministic protected array `y_cat`, where `y_cat[i] = y[i] + 1`, so the protected observation can be scored once with a plain top-level left-hand side. Added `K = max(t) + 1` as deterministic support size data. The original zero-inflated/binomial mixture likelihood is represented as a single vectorized built-in `categorical` likelihood: category 1 corresponds to original `y = 0`, category `k + 1` corresponds to original `y = k`, and categories above `t[i] + 1` have probability 0. Parameter priors were moved before parameter-dependent model-block computations, and the manual `target +=` likelihood with an `if` on the observation was replaced by the equivalent built-in sampling statement. The data variable `x` is retained as an ordinary context input and is unused, as in the original model.
