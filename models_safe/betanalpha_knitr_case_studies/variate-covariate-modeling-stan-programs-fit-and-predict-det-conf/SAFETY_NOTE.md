# SafeStan Safety Note

Compatibility: minor.

Protected data: `x1`, `y1`, and `x2`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the user-defined `gamma_ld` sampling distribution with equivalent built-in `gamma` sampling statements. The original helper used `beta = inv(phi)` and `alpha = beta * mu`, which is preserved directly in the rewritten likelihoods. The generated-quantities calls to `gamma_ld_rng` were likewise replaced by equivalent built-in `gamma_rng` calls. The data file is unchanged; no deterministic copies or new observations were added.
