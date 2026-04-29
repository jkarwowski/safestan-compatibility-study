# SafeStan Safety Note

Compatibility: minor.

Protected data: `yc` and `yb_safestan_flat`. The protected `yb_safestan_flat` represents the original binary observation array `yb` as a deterministic column-major flattening: `yb_safestan_flat[(k - 1) * N + n] = yb[n, k]` for `n = 1..N` and `k = 1..Kb`, matching `to_vector(z)`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `yb_safestan_flat` to the data as a deterministic reshape of `yb`; moved the computation of `z` into the `model` block after `yc` has been observed, because `z` depends on protected `yc`; vectorized the `zb` prior into a single top-level parameter sampling statement; and replaced the looped/indexed binary likelihood with one built-in `bernoulli_logit` statement on the protected flat copy. These are mechanical same-density changes for data satisfying the documented deterministic copy relation.
