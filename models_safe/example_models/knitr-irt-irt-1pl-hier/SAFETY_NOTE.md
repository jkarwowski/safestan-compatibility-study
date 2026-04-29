# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the likelihood from a loop over indexed slices `y[i] ~ bernoulli_logit(...)` to a single plain protected-data sampling statement `y ~ bernoulli_logit(eta)`. The local array `eta` is deterministically filled after all parameter priors have been stated, preserving the same Bernoulli-logit likelihood terms. No data changes were required.
