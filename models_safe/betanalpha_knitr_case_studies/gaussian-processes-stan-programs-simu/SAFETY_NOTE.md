# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model-block sampling statement for any top-level data variable; all data variables (`N`, `x`, `rho`, and `alpha`) are context inputs used to construct the Gaussian-process covariance for simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block is empty, there are no parameters requiring priors, and the generated-quantities RNG draw does not contribute to the log density.
