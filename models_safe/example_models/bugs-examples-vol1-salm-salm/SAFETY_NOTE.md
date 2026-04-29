# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model scored `lambda[dose]` and `y[dose]` inside a loop. The SafeStan version replaces these with one top-level prior statement for `lambda` and one top-level likelihood statement for `y`. To make the vectorized prior and likelihood syntactically SafeStan-compatible, `lambda` was mechanically represented as an equivalent two-dimensional real array, and a local `eta` array is filled deterministically after all parameter priors. The data are unchanged.
