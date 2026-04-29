# SafeStan Safety Note

Compatibility: minor.

Protected data: `y1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the user-defined likelihood `gamma_ld(...)` with the equivalent built-in Stan `gamma(...)` likelihood using `beta = inv(psi)` and `alpha = beta * (lambda * x1)`. This preserves the original density `gamma_lpdf(y1 | alpha, beta)` while satisfying SafeStan's requirement that protected observations be scored by a built-in distribution. The unused user-defined `gamma_ld_lpdf` was removed; the generated-quantities RNG helper was retained. No data changes were made.
