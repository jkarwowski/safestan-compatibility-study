# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the per-observation likelihood loop `y[n] ~ bernoulli_logit(...)` into a single top-level protected observation statement `y ~ bernoulli_logit(eta)`. The local model-block vector `eta` is computed deterministically from already-prior-sampled parameters and context data (`jj`, `kk`, `N`). This preserves the same Bernoulli-logit likelihood while satisfying SafeStan's requirement that protected data appear exactly once on the left side of a plain sampling statement outside loops. No data fields were added or changed.
