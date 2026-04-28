# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_failures`, the failure-count version of the original trial-count data `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic shift `y_failures[n] = y[n] - 1` from Stan `transformed data` into `data_safe.json`, and made `y_failures` a top-level data variable so it can be protected and scored directly. The original `y` vector is recoverable as `y_failures[n] + 1`, so this is a one-to-one deterministic reshape of the observations and preserves the posterior/log density. The parameter prior `theta ~ beta(1, 1)` and the likelihood distribution are otherwise unchanged.
