# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program does not condition on any top-level data variable with a sampling statement; all data inputs (`N`, `x`, `rho`, and `alpha`) are context inputs used to configure the generated simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block is empty, there are no parameters requiring priors, and there are no protected observations to score. The generated quantities block simulates new quantities and does not define an observed likelihood.
