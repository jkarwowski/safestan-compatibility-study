# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model does not condition on any top-level data variable with a sampling statement; `N` and `x` are context/configuration inputs used to construct the Gaussian-process covariance for prior predictive simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `eta ~ normal(0, 1)` for the top-level parameter `eta`, and there are no protected observations to score.
