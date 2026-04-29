# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan`, a deterministic flattened top-level copy of the transformed observations originally scored as `y[dog, trial]` for `trial = 2, ..., Ntrials`. The deterministic relation is `y_safestan[(dog - 1) * (Ntrials - 1) + (trial - 1)] = 1 - Y[dog, trial]` using the same dog-major order as the original nested loops. The indexed likelihood inside loops was replaced by one vectorized built-in Bernoulli sampling statement on the protected top-level variable. Parameter priors were already explicit and remain unchanged.

For the supplied synthetic data this adds `"y_safestan": [-1]`, preserving the supplied values under the deterministic transformation without inventing or repairing observations.
