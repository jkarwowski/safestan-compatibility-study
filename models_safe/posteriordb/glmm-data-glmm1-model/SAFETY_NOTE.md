# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the observation likelihood so the protected top-level data variable `obs` is scored exactly once with a plain `obs ~ poisson_log(...)` statement outside the loop. Reordered priors so hyperparameters are scored before use, and added the explicit `sd_alpha ~ uniform(0, 5)` prior corresponding to the original finite bounded parameter constraint. The likelihood helper vector is computed only after all parameter priors. No observed counts are changed.
