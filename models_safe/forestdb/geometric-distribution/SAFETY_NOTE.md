# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_failures`, a deterministic shifted copy of the original observations with `y_failures[n] = y[n] - 1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved `y_failures` from `transformed data` to top-level `data` so the observed likelihood variable is a plain protected data identifier on the left side of a built-in sampling statement. The supplied `data_safe.json` adds `y_failures` deterministically from `y`; for this run, `[1]` becomes `[0]`. The prior on `theta` and the negative-binomial likelihood are otherwise unchanged.
