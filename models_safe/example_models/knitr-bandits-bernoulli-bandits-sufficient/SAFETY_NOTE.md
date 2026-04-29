# SafeStan Safety Note

Compatibility: minor.

Protected data: `successes`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the sufficient-statistic observation from `transformed data` to top-level data, because SafeStan only permits top-level protected data on the left side of a sampling statement. In `data_safe.json`, `trials[k]` is computed as the number of trials with `z[n] == k`, and `successes[k]` is computed as the sum of `y[n]` over those trials; for the supplied data this gives `trials = [0, 1, 0]` and `successes = [0, 0, 0]`. The per-arm sufficient-statistic arrays are declared with length `K`. Added `theta ~ uniform(0, 1)`, which is density-neutral for the existing `[0, 1]` constraint and satisfies SafeStan's unique-prior requirement.
