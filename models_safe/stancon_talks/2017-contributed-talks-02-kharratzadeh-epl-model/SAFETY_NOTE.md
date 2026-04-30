# SafeStan Safety Note

Compatibility: minor.

Protected data: `score_diff`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: flattened matrix parameter `eta_a` to `eta_a_flat` for a single top-level normal prior, rebuilt the matrix deterministically, kept the protected `score_diff` likelihood as one vectorized top-level `student_t` statement, and adjusted synthetic `nweeks` to cover supplied week indexes.
