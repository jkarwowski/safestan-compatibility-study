# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the likelihood already observes the top-level data variable `Y` exactly once using a built-in distribution. The model was rewritten mechanically by moving all parameter prior statements before any model-block use of those parameters. The `alpha` prior loop was vectorized as `alpha ~ multi_normal(gamma, Sigma);` so that the top-level parameter `alpha` is sampled once and no parameter-prior sampling statement appears inside a loop. No data transformation is required; `data_safe.json` is the supplied data unchanged.
