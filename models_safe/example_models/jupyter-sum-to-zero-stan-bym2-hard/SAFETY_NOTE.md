# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered all parameter prior sampling statements before the protected-data likelihood. Replaced the ICAR `target +=` quadratic prior for `phi_raw` with an equivalent built-in `multi_normal_prec` prior using a transformed-data precision matrix computed deterministically from `neighbors` and the hard sum-to-zero basis. No data fields were added; `data_safe.json` is unchanged. The protected observation remains the top-level variable `y`, observed exactly once with `poisson_log`.
